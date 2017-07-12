require.config({ paths: { 'vs': 'monaco-editor/min/vs' }});

var startMonaco = function() {

  var res = [];
  var elems = document.getElementsByName("lambs");
  require(['vs/editor/editor.main'], function() {

    for (var i = 0; i < elems.length; i++) {
      var elem = elems[i];
      if (elem.getAttribute("prelude") === "true") {
        res.push(startPreluditor(elem));
      } else {
        res.push(startEditor(elem));
      }

    }});
    return res;
};

var startPreluditor = function(element) {
  var elemContent = element.textContent;
  element.textContent = "";
  var content = "";
  var lines = elemContent.split(/\r?\n/);
  for (var i = 0; i < lines.length; i++) {
    var line = lines[i];
    if (line.trim().length > 0) {
      var parsed = lambs.parse(line);
      updateDefs(parsed);
      content += line + "\n" + lambs.step(parsed) + "\n";
    } else {
      content += "\n";
    }
  }

  var editor = monaco.editor.create(element, {
      value: content,
      lineNumbers: false,
      quickSuggestions: false,
      mouseWheelZoom: true,
      readOnly: true
  });

  return editor;

}

var startEditor = function(element) {

    var content = element.textContent;
    element.textContent = "";

    var editor = monaco.editor.create(element, {
        value: content,
        lineNumbers: false,
        quickSuggestions: false,
        mouseWheelZoom: true
    });

    editor.addCommand([monaco.KeyMod.CtrlCmd | monaco.KeyCode.KEY_L], function() {
        var range = editor.getSelection();
        var id = { major: 1, minor: 1 };
        var text = 'λ';
        var op = {identifier: id, range: range, text: text, forceMoveMarkers: true};
        editor.executeEdits("lambs", [op]);
    });

    editor.addCommand([monaco.KeyMod.CtrlCmd | monaco.KeyCode.KEY_D], function() {
        var range = editor.getSelection();
        var id = { major: 1, minor: 1 };
        var text = '≜';
        var op = {identifier: id, range: range, text: text, forceMoveMarkers: true};
        editor.executeEdits("lambs", [op]);
    });

    editor.addCommand([monaco.KeyMod.CtrlCmd | monaco.KeyCode.Enter], function() {
        var selection = editor.getSelection();
        var line = selection.positionLineNumber;
        var model = editor.getModel();
        var s = model.getLineContent(line);
        var pos = new monaco.Position(line, s.length + 1);
        editor.setPosition(pos);
        var range = editor.getSelection();
        var id = { major: 1, minor: 1 };
        var parsed = lambs.parse(s);
        updateDefs(parsed);
        var text = '\n' + lambs.step(parsed);
        var op = {identifier: id, range: range, text: text, forceMoveMarkers: true};
        editor.pushUndoStop();
        editor.executeEdits("lambs", [op]);
        editor.pushUndoStop();
        editor.revealPosition(editor.getPosition());
    });

    editor.addCommand([monaco.KeyMod.CtrlCmd | monaco.KeyMod.Shift | monaco.KeyCode.Enter], function() {
        var selection = editor.getSelection();
        var line = selection.positionLineNumber;
        var model = editor.getModel();
        var s = model.getLineContent(line);
        var pos = new monaco.Position(line, s.length + 1);
        editor.setPosition(pos);
        var range = editor.getSelection();
        var id = { major: 1, minor: 1 };
        var parsed = lambs.parse(s);

        var next = lambs.step1(parsed);
        var text = '\n' + lambs.execStr(next);

        var edits;
        if (lambs.isJust(next)) {
          edits = [];
        } else {
          edits [{identifier: id, range: range, text: text, forceMoveMarkers: true}];
        }

        var i = 0;
        while (lambs.isJust(next) && i < 1000) {
            text = '\n' + lambs.execStr(next);
            edits.push({identifier: null, range: range, text: text, forceMoveMarkers: true});
            next = lambs.stepn(next);
            i = i + 1;
        }
        editor.pushUndoStop();
        editor.executeEdits("lambs", edits);
        editor.pushUndoStop();
        editor.revealPosition({lineNumber: editor.getPosition().lineNumber, column: 0});
    });

    editor.addCommand([monaco.KeyMod.CtrlCmd | monaco.KeyCode.KEY_R], function() {
        var selection = editor.getSelection();
        var line = selection.positionLineNumber;
        var model = editor.getModel();
        var s = model.getLineContent(line);
        var pos = new monaco.Position(line, s.length + 1);
        editor.setPosition(pos);
        var range = editor.getSelection();
        var id = { major: 1, minor: 1 };
        var parsed = lambs.parse(s);
        var text = '\n' + lambs.renameDefs(defs)(parsed);
        var op = {identifier: id, range: range, text: text, forceMoveMarkers: true};
        editor.pushUndoStop();
        editor.executeEdits("lambs", [op]);
        editor.pushUndoStop();
        editor.revealPosition(editor.getPosition());
    });

    editor.addAction({
	     id: 'defs-action-id',
	     label: 'Show definitions',

	     keybindingContext: null,

	     contextMenuGroupId: 'navigation',

	     contextMenuOrder: 1.5,

	     run: function(ed) {
              var selection = ed.getSelection();
              var line = selection.positionLineNumber;
              var model = ed.getModel();
              var s = model.getLineContent(line);
              var pos = new monaco.Position(line, s.length + 1);
              ed.setPosition(pos);
              var range = ed.getSelection();
              var id = { major: 1, minor: 1 };
              var parsed = lambs.parse(s);
              var text = '\n' + lambs.defsString(defs);
              var op = {identifier: id, range: range, text: text, forceMoveMarkers: true};
              ed.pushUndoStop();
              ed.executeEdits("lambs", [op]);
              ed.pushUndoStop();
              ed.revealPosition(ed.getPosition());
	         }});
    return editor;
};


var editors = startMonaco();

var refreshEditors = function() {
  for (var i = 0; i < editors.length; i++) {
    editors[i].layout();
  }
};
