var console = require('browser/console'),
    editor  = require("lalala/modules/editor");

$(function(){
  $('select').chosen();
  editor.init();
});
