/* vim: set ts=2 sts=2 sw=2 et tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";
             
function getAllImageHandler() {
  var allImageSrc = [];
  let imageSet = new Set();
  let regex = /\s*.(jpg|png|jpeg|gif)$/ig;
  let htmlRegex = /\s*.html$/ig;
    
  [].slice.apply(document.getElementsByTagName("img")).forEach(function(el) {
      var src = el.src;

      //直接遍历所有的属性, 找出下标为png/jpg/jpeg/gif的值(不太严谨,有些url并不会有后缀名)
      //例如m.u17.com会把未加载的src置为xxx.html
      //m.kumw5.com酷漫网会把没有加载的src置为加载动图xx.gif
      //酷漫网
      //<img class="lazy" data-original="https://p3.byteimg.com/origin/fe3900020202941e6817" src="https://p3.byteimg.com/tos-cn-i-8gu37r9deh/c146486cbdb54383a5c3ee6340617816~noop.gif">
      for(var i=0;i<el.attributes.length;i++) {
          var attr = el.attributes[i];
          var nodeName = attr.nodeName;
          var nodeValue = attr.nodeValue;

          if(nodeValue != null && nodeValue != undefined
             && (typeof nodeValue == 'string') && nodeValue != ''
             && nodeValue != 'none') {
              //变成了对象
              var url = new URL(nodeValue, window.document.baseURI);
              //需要转换成string
              var urlString = url.toString();
              if(regex.test(urlString) && imageSet.has(urlString) == false) {
                  allImageSrc.push(urlString);
                  imageSet.add(urlString);
              }
          }
      }
  });
  
//    "url(\"https://bkimg.cdn.bcebos.com/smart/027a45b54b75d58b37d3ca42-bkimg-process,v_1,rw_3,rh_2,maxl_800?x-bce-process=image/format,f_auto\")"
        //需要处理这样格式的字符串,把url提取出来
  [].slice.apply(document.querySelectorAll("[style*=\"background\"]")).forEach(function(el) {
      var backgroundImage = el.style.backgroundImage;
      if (typeof(backgroundImage) != "undefined" && backgroundImage != "" && backgroundImage != "initial"){
          var src = backgroundImage.replace('url(\"','').replace('\")','');
          if(src != "none" && src != "") {
              let url = new URL(src, window.document.baseURI);
              //需要转换成string
              var urlString = url.toString();
              if(imageSet.has(urlString) == false) {
                  allImageSrc.push(urlString);
                  imageSet.add(urlString);
              }
          }
      }
  });
      
    webkit.messageHandlers.getAllImageHelper.postMessage({'res': JSON.stringify(allImageSrc)});
}

Object.defineProperty(window.__firefox__, "getAllImageHandler", {
  enumerable: false,
  configurable: false,
  writable: false,
  value: getAllImageHandler
});



