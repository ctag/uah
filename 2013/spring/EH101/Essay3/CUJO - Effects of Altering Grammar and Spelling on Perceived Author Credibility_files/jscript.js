
//open new window
function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}



//toc function
function toc(){
   if(document.getElementById){
      var nodecol=document.getElementById('article_content').childNodes;
      var nodelng=nodecol.length;
      var nodecnt='';
      var toc='';
      var nest=tocndx=0;
      for(var i=1;i<nodelng;i++){
         if(nodecol[i].tagName=='H1'||nodecol[i].tagName=='H2'
            ||nodecol[i].tagName=='H3'){
            nest=parseInt(nodecol[i].tagName.substr(1));
            nodecnt=nodecol[i].innerHTML;
            for(var j=1;j<=nest;j++)
               toc+='<ul>';
            toc+='\n<li><a href="#jump'+i+'">'+
               nodecnt.replace(/<\/?a[^>]*>/gi,"")+'</a></li>\n';
            for(var j=1;j<=nest;j++)
               toc+='</ul>';
            nodecol[i].innerHTML=
               '<a name="jump'+i+'"></a>'+nodecnt;
            tocndx++;}}
      if(tocndx>1){
         document.getElementById('toc').innerHTML=
            '<p><strong>Contents:</strong></p><div id="toccnt">\n'+toc+'\n</div>';
         document.getElementById('toc').className='mmhide_toc';}}}