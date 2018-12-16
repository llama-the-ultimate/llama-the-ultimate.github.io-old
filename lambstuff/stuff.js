/* fp.js */

const tag = t => {
  function halp() {
    return { tag: t, values: [... arguments] }
  }
  return halp;
};

const match = (x, cases) => {

  const errar = () => { throw { message: "match failed", value: x, cases: cases }};

  if (!x || !x.hasOwnProperty("tag")) {
    errar();
  }
  if (cases.hasOwnProperty(x.tag)) {
    return cases[x.tag].apply(null, x.values);
  }
  if (cases.hasOwnProperty("default")) {
    return cases["default"](x);
  }
  errar();;
}
const matchf = cases => x => match(x, cases);

const Just = tag("Just");
const Nope = tag("Nope")();

/* exp.js */

const Var = tag("Var");
const Lam = tag("Lam");
const App = tag("App");

/* parse.js */

const ParseError = tag("ParseError");
const Define = tag("Define");
const Undefine = tag("Undefine");
const Expression = tag("Expression");

const parse = (() => {

  const ParseResult = tag("ParseResult");


  const isLambda = code => code === 92 || code === 955;
  const isWhite = code => code === 32 || code === 9 || code === 10 || code === 13;
  const isDot = code => code === 46;

  const isDef = code => code === 8796;
  const isColon = code => code === 58;
  const isEquals = code => code === 61;

  const isId = code => !(isLambda(code) || isWhite(code) || isDot(code) || isOpen(code) || isClose(code) || isDef(code) || isColon(code) || isEquals(code));

  const isOpen = code => code === 40;
  const isClose = code => code === 41;

  const isBar = code => code === 124;

  const strCode = ([s, i]) => s.charCodeAt(i);
  const strAtEnd = ([s, i]) => i >= s.length || isBar(strCode([s, i]));

  const parseExtract =
    matchf({ParseResult: (str, x) => [str, x],
            default: x => { throw x; }});

  const isParseError =
    matchf({ParseResult: r => false,
            ParseError: u => true});

  const parseBind = (x, f) =>
    match(x,
          {ParseResult: f,
           ParseError: e => x});

  const parseMap = (x, f) => parseBind(x, y => ParseResult(f(y)));

  const skipChars = pred => ([s, i]) => {
    var idx;
    for (idx = i; idx < s.length; idx++) {
      if (!pred(s.charCodeAt(idx))) {
        break;
      }
    }
    return idx;
  }

  const skipWhites = skipChars(isWhite);

  const parseIdentifier = ([s, startI]) => {
    const stopI = skipChars(isId)([s, startI]);
    return stopI === startI
      ? ParseError("expected identifier",  stopI)
      : ParseResult(s.substr(startI, stopI - startI), stopI);
  };

  const parseLambda = ([s, lamI]) => {
    if (!isLambda(strCode([s, lamI]))) {
      return ParseError("expected lambda", lamI);
    }

    const paramStartI = skipWhites([s, lamI + 1]);
    const paramRes = parseIdentifier([s, paramStartI]);
    if (isParseError(paramRes)) {
      return paramRes;
    }
    const [param, paramStopI] = parseExtract(paramRes);
    const dotI = skipWhites([s, paramStopI]);

    if (!isDot(strCode([s, dotI]))) {
      return ParseError("expected dot", dotI);
    }

    return match(parseApps([s, dotI + 1]),
                 {ParseResult: (body, nextI) => ParseResult(Lam(param, body), nextI),
                default: x => x});
  };

  const parseOne = ([s, startI]) => {
    const code = strCode([s, startI]);
    if (isId(code)) {
      return parseBind(parseIdentifier([s, startI]), (v, i) => ParseResult(Var(v), i));
    }
    if (isLambda(code)) {
      return parseLambda([s, startI]);
    }
    if (isOpen(code)) {
      const res = parseApps([s, startI + 1]);
      if (isParseError(res)) {
        return res;
      }
      const [x, closeI] = parseExtract(res);
      if (!isClose(strCode([s, closeI]))) {
        return ParseError("expected close paren", closeI);
      }
      return ParseResult(x, closeI +1);
    }
  };

  const parseApps = ([s, beforeI]) => {
    const exps = [];
    var currentI = beforeI;
    while (true) {
      currentI = skipWhites([s, currentI]);
      if (strAtEnd([s, currentI])) {
        break;
      }
      const code = strCode([s, currentI]);
      if (!(isId(code) || isLambda(code) || isOpen(code))) {
        break;
      }
      const res = parseOne([s, currentI]);
      if (isParseError(res)) {
        return res;
      }
      const [exp, nextI] = parseExtract(res);
      exps.push(exp);
      currentI = nextI;
    }

    if (exps.length === 0) {
      return ParseError("expected _something_", currentI);
    }
    return ParseResult(makeApps(exps), currentI);
  }

  const makeApps = exps => {
    var res = exps[0];
    for (var i = 1; i < exps.length; i++) {
      res = App(res, exps[i]);
    }
    return res;
  }

  const parseExpression = ([s, startI]) => {
    const res = parseApps([s, startI]);
    if (isParseError(res)) {
      return res;
    }
    const [exp, stopI] = parseExtract(res);
    if (!strAtEnd([s, stopI])) {
      return ParseError("expected _not that_", stopI);
    }
    return res;
  }

  const parseDef = name => ([s, i]) =>
    isDef(strCode([s, i]))
    ? ParseResult(name, i + 1)
    : isColon(strCode([s, i])) && isEquals(strCode([s, i + 1]))
    ? ParseResult(name, i + 2)
    : ParseError("expected ≜ or :=", i);

  const parse = s => {
    const startI = skipWhites([s, 0]);
    const defRes =
      parseBind(parseIdentifier([s, startI]),
                (name, afterIdI) => parseDef(name)([s, skipWhites([s, afterIdI])]));

    return match(defRes,
                 {ParseResult: (name, afterDefId) =>
                    strAtEnd([s, skipWhites([s, afterDefId])])
                    ? Undefine(name)
                    : parseBind(parseExpression([s, afterDefId]), (exp, u) => Define(name, exp)),
                 ParseError: (um, ui) => parseBind(parseExpression([s, 0]), (exp, ui) => Expression(exp))});
  };
  return parse;
})();

/* unparse.js */

const unparse = (() => {

  const pstring = s => "(" + s + ")";

  const argstring =
    matchf({Var: s => s,
            default: x => pstring(unparse(x))});

  const fstring = x => match(x,
                             {Lam: (p, b) => pstring(unparse(x)),
                              default: u => unparse(x)});

  const unparse =
    matchf({Var: s => s,
            Lam: (p, b) => "λ" + p + "." + unparse(b),
            App: (f, a) => fstring(f) + " " + argstring(a)});

  return unparse;
})();

/* path.js */

const LamStep = tag("LamStep");
const AppFunStep = tag("AppFunStep");
const AppArgStep = tag("AppArgStep");

const Stop = tag("Stop")();

const Found = tag("Found");

const findExp = (pred, exp, path) =>
  match(pred(exp),
        {Nope: () =>
           match(exp,
                 {Var: () => Nope,
                  Lam: (p, b) => findExp(pred, b, LamStep(p, path)),
                  App: (f, a) =>
                    match(findExp(pred, f, AppFunStep(a, path)),
                          {Found: (p, f) => Found(p, f),
                           Nope: u => findExp(pred, a, AppArgStep(f, path))})}),
         Just: x => Found(path, x)});

const assembleExp = (path, missing) =>
  match(path,
        {LamStep: (p, rest) => assembleExp(rest, Lam(p, missing)),
         AppFunStep: (a, rest) => assembleExp(rest, App(missing, a)),
         AppArgStep: (f, rest) => assembleExp(rest, App(f, missing)),
         Stop: () => missing});

/* subst.js */

const redex = matchf({App: (f, a) => match(f,
                                           {Lam: (p, b) => Just([a, p, b]),
                                            default: u => Nope}),
                      default: u => Nope});

const subst = ([ra, rp, rb]) => {
  const halp = matchf({Var: v => rp === v ? ra : Var(v),
                       Lam: (p, b) => rp === p ? Lam(p, b) : Lam(p, halp(b)),
                       App: (f, a) => App(halp(f), halp(a))});
  return halp(rb);
};

/* eval.js */

const Reduce = tag("Reduce");
const Rename = tag("Rename");
const Normal = tag("Normal");

const stepExec = (() => {

  const S = {empty: new Set(),
             single: (a) => new Set([a]),
             union: (a, b) => new Set([...a, ...b]),
             add: (a, s) => new Set([a, ...s]),
             member: (a, s) => s.has(a)};

  const allIds =
    matchf({Var: s => S.single(s),
            Lam: (p, b) => S.add(p, allIds(b)),
            App: (f, a) => S.union(allIds(f), allIds(a))});

  const uniqueId = (s, used) => {
    const idNum = /^([a-zA-Z0-9]*?)([0-9]+)$/.exec(s);
    var id;
    var num;
    if (idNum) {
      id = idNum[1];
      num = parseInt(idNum[2]);
    } else {
      id = s;
      num = 1;
    }

    while (true) {
      num = num + 1;
      const res = id + num;
      if (!S.member(res, used)) {
        return res;
      }
    }
  };

  const freeIds = exp => {
    const halp = (used, x) => {
      return match(x,
                   {Var: s => S.member(s, used) ? S.empty : S.single(s),
                    Lam: (p, b) => halp(S.add(p, used), b),
                    App: (f, a) => S.union(halp(used, f), halp(used, a))});
    };
    return halp(S.empty, exp);
  }

  const Conflict = tag("Conflict");

  const conflict = (param, bad, exp) =>
    match(exp,
          {Lam: (p, b) => p !== param && S.member(p, bad) && S.member(param, freeIds(b)) ? Conflict(p, b) : Nope,
           default: u => Nope});

  const findConflict = ([arg, param, body], startPath) => {
    const freeInArg = freeIds(arg);
    const find = (path, exp) => {

      const next = matchf({Var: v => Nope,
                           Lam: (p, b) => p === b ? Nope : find(LamStep(p, path), b),
                           App: (a, f) =>
                             match(find(AppFunStep(a, path), f),
                                   {Found: (rpath, rconflict) => Found(rpath, rconflict),
                                    Nope: () => (find(AppArgStep(f, path), a))})});

      return match(conflict(param, freeInArg, exp),
                   {Conflict: (p, b) => Found(path, Conflict(p, b)),
                    Nope: () => next(exp)});
    };
    return find(startPath, body);
  };

  const renameStuff = (path, [ra, rp, rb], cpath, param, body, outer) => {
    const newParam = uniqueId(param, allIds(outer));
    const renamed = Lam(newParam, subst([Var(newParam), param, body]));
    return Rename(param, outer, newParam, assembleExp(path, App(Lam(rp, assembleExp(cpath, renamed)), ra)))
  }

  const stepExec = exp =>
    match(findExp(redex, exp, Stop),
          {Nope: u => Normal(exp),
           Found: (path, [ra, rp, rb]) =>
             match(findConflict([ra, rp, rb],Stop),
                   {Nope: u => Reduce(exp, assembleExp(path, subst([ra, rp, rb]))),
                    Found: (cpath, conf) =>
                      match(conf,
                            {Conflict: (param, body) => renameStuff(path, [ra, rp, rb], cpath, param, body, exp)})})});
  return stepExec;
})();

/* js.js */

const [evalExp, evalString, replaceDefs] = (() => {

  const removeDef = (oldDefs, s) => {
    const defs = [... oldDefs];
    for (var i = 0; i < defs.length; i++) {
      if (s === defs[i][0]) {
        defs.splice(i, 1);
      }
    }
    return defs;
  };

  const addDef = (oldDefs, [s, x]) => {
    const defs = [... oldDefs];
    for (var i = 0; i < defs.length; i++) {
      if (s === defs[i][0]) {
        defs[i] = [s, x];
        return defs;
      }
    }
    defs.push([s, x]);
    return defs;
  }

  const evalExp = x => match(stepExec(x),
                                    {Normal: exp => ["\n" + unparse(exp), false],
                                     Reduce: (a, b) => ["\n" + unparse(b), b],
                                     Rename: (oldV, oldExp, v, exp) => [" | [" + v + "/" + oldV + "]" + "\n" + unparse(exp), exp]});

  const evalString = (defs, str) =>
    match(parse(str),
          {Expression: x => [defs, ... evalExp(x)],
           Define: (name, exp) => [addDef(defs, [name, exp]), "\n" + name + " is defined :)", false],
           Undefine: name => [removeDef(defs, name), "\n" + name + " is undefined :|", false],
           ParseError: (msg, i) => [defs, "\n" + new Array(i + 1).join(" ") + "^\noh no: " + msg, false]});


  const substDefs = (defs, exp) => {
    var res = exp;
    for (var i = defs.length - 1; i >= 0; i--) {
      const [s, x] = defs[i];
      res = subst([x, s, res]);
    }
    return res;
  }

  const replaceDefs = (defs, str) =>
    match(parse(str),
          {Expression: x => "\n" + unparse(substDefs(defs, x)),
           ParseError: (msg, i) => "\n " + new Array(i).join(" ") + "^\noh no: " + msg,
           default: u => "\nplox replacestuff on normal expressions only?"});

  return [evalExp, evalString, replaceDefs];
})();

/* main.js */

var defs = [];

const eval1 = cont => cm => {
  const line = cm.getCursor().line;
  const str = cm.getLine(line);
  const [newDefs, res, nextExp] = evalString(defs, str);
  defs = newDefs;
  cm.operation(() => insertResult(cm, res));

  if (nextExp !== false) {
    cont(cm, nextExp);
  }
}

const evalN = maxSteps => (cm, exp) => {
  var res;
  var nextExp = exp;
  for (var i = 0; i < maxSteps; i++) {
    [res, nextExp] = evalExp(nextExp);
    if (nextExp === false) {
      return;
    }
    cm.operation(() => insertResult(cm, res));
  }
}

const insertResult = (cm, str) => {
    const line = cm.getCursor().line;
    const pos = {line: line, ch: cm.getLine(line).length};
    cm.replaceRange(str, pos, pos, "lambs");
    const newPos = {line: line + 1, ch: str.length};
    cm.setSelection(newPos, newPos, {origin: "lambs"});
};


const replaceStuff = cm => {
  const res = replaceDefs(defs, cm.getLine(cm.getCursor().line));
  insertResult(cm, res);
}




const keyMap = {};
keyMap["Ctrl-Enter"] = eval1((cm, exp) => {});
keyMap["Shift-Ctrl-Enter"] = eval1(evalN(1000));
keyMap["Shift-Ctrl-R"] = replaceStuff;
keyMap["Ctrl-R"] = replaceStuff;
keyMap["Ctrl-L"] = cm => cm.replaceSelection("λ");
keyMap["Ctrl-D"] = cm => cm.replaceSelection("≜");

const evalPrelude = str => {
  const lines =str.split(/\r?\n/).map(line => {
    if (line.trim().length > 0) {
      const [newDefs, res, nextExp] = evalString(defs, line);
      defs = newDefs;
      return line + res;
    } else {
      return "";
    }
  });
  return lines.join("\n");
};

const editorProps = str =>
({
  value: str,
  lineNumbers: true,
  extraKeys: keyMap
});

const preluditorProps = str =>
({
  value: evalPrelude(str),
  lineNumbers: true,
  readOnly: true
});

const makeEditor = elem => {
  const str = elem.innerText;
  elem.innerText = "";
  const props =
    elem.getAttribute("prelude") === "true"
    ? preluditorProps(str)
    : editorProps(str);

  return CodeMirror(elem, props);
};

const editors = [... document.getElementsByName("lambs")].map(e => makeEditor(e));
