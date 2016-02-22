angular.module('starter.services', [])

  .factory('locals',['$window',function($window){
    return{

      set :function(key,value){
        $window.localStorage[key]=value;
      },
      get:function(key,defaultValue){
        return  $window.localStorage[key] || defaultValue;
      },

      setObject:function(key,value){
        $window.localStorage[key]=JSON.stringify(value);
      },

      getObject: function (key) {
        return JSON.parse($window.localStorage[key] || '{}');
      }

    }
  }])
    .factory('Products', function(){
        var products = [
            { "name" : "爱必赚1号",
                "begin" : "5000",
                "rate" : 10.2,
                "month" : 24,
                "status" : "在售"
            },
            { "name" : "爱必赚2号",
                "begin" : "5000",
                "rate" : 12.3,
                "month" : 28,
                "status" : "售罄"
            }
        ];
        return{
            all: function()
            {
                return products;
            }
        };
    }
)
.factory('Chats', function() {
  // Might use a resource here that returns a JSON array

  // Some fake testing data
  var chats = [{
    id: 0,
    name: 'Ben Sparrow',
    lastText: 'You on your way?',
    face: 'img/ben.png'
  }, {
    id: 1,
    name: 'Max Lynx',
    lastText: 'Hey, it\'s me',
    face: 'img/max.png'
  }, {
    id: 2,
    name: 'Adam Bradleyson',
    lastText: 'I should buy a boat',
    face: 'img/adam.jpg'
  }, {
    id: 3,
    name: 'Perry Governor',
    lastText: 'Look at my mukluks!',
    face: 'img/perry.png'
  }, {
    id: 4,
    name: 'Mike Harrington',
    lastText: 'This is wicked good ice cream.',
    face: 'img/mike.png'
  }];

  return {
    all: function() {
      return chats;
    },
    remove: function(chat) {
      chats.splice(chats.indexOf(chat), 1);
    },
    get: function(chatId) {
      for (var i = 0; i < chats.length; i++) {
        if (chats[i].id === parseInt(chatId)) {
          return chats[i];
        }
      }
      return null;
    }
  };
});
