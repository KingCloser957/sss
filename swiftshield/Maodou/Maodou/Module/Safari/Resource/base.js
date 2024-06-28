try {
    (function() {
         function emitEvent(event) {
             var hookBridge = window.webkit.messageHandlers.NEWebHookBridge;
             if (hookBridge) {
                 hookBridge.postMessage({
                   "type": "lifeCycle",
                   "data": {
                     "event": event,
                   }
                 });
             }
         }
         function onDomReady() {
             emitEvent('DOMContentLoaded');
         }
         
         function onLoad() {
             emitEvent('load')
         }
         
         if (document.readyState === 'interactive') {
             onDomReady()
         } else {
             window.addEventListener('DOMContentLoaded', onDomReady)
         }
         
         if (document.readyState === 'complete') {
             onLoad()
         } else {
             window.addEventListener('load', onLoad)
         }

         window.addEventListener('pageshow', (event) => {
          if (event.persisted) {
            // retrieve state pageshow
            if (document.readyState === 'interactive') {
              onDomReady()
            } else if (document.readyState === 'complete') {
              onLoad()
            }
          }
        });

        window.addEventListener('beforeunload', (event) => {
            cosole.log(event);
        });
    })();
} catch (error) {
  
}

(function(){
  try{
    window.history.pushState = (function(fn){
      return function(){
        var args = [].slice.call(arguments);
         window.webkit.messageHandlers.pushStateChange.postMessage({url:args.length > 2 ? args[2] : ""})
        fn.apply(this,args);
      }
    })(window.history.pushState);

    window.history.replaceState = (function(fn){
      return function(){
        var args = [].slice.call(arguments);
        window.webkit.messageHandlers.pushStateChange.postMessage({url:args.length > 2 ? args[2] : ""})
        fn.apply(this,args);
      }
    })(window.history.replaceState);
  }catch(ex){

  }
})();



