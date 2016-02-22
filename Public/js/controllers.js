angular.module('starter.controllers', [])
  .controller('device',function($scope){
    $scope.level = 6;
  })
  .controller('MainCtrl', function($scope, $ionicSlideBoxDelegate, locals){
    // 读取是否显示welcome的标志
    var wel = locals.get("welcome",true);

    if(wel == true){
      $scope.welcome = true;

      // 不管用户是否完整看完了Welcome界面，下一次启动均不显示
      locals.set("welcome", false);
    }

    // 用户手动关闭Welcome界面
    $scope.closeWelcome = function(){
      delete($scope.welcome);
       $ionicSlideBoxDelegate.update();
    }
  })

.controller('DashCtrl', function($scope) {})

.controller('ChatsCtrl', function($scope, $http, Chats) {
  // With the new view caching in Ionic, Controllers are only called
  // when they are recreated or on app start, instead of every page change.
  // To listen for when this page is active (for example, to refresh data),
  // listen for the $ionicView.enter event:
  //
  //$scope.$on('$ionicView.enter', function(e) {
  //});

      $scope.chats = Chats.all();
      $http({
      url:'http://localhost/index.php/home/bestforbaby?way=ngview',
      method:'GET'
      }).success(function(newItems) {
       console.log("success");
       //$scope.chats = newItems;
     }).error(function(){
      console.log("fail");
      //$scope.chats = Chats.all();
     })

  $scope.remove = function(chat) {
    Chats.remove(chat);
  };
})

.controller('ChatDetailCtrl', function($scope, $stateParams, Chats) {
  $scope.chat = Chats.get($stateParams.chatId);
  $scope.chats = Chats;
  $scope.photoSlides = 0;
})
.controller('LoginCtrl', function($scope,$http) {

})

.controller('AccountCtrl', function($scope) {
  $scope.settings = {
    enableFriends: true
  };
})
.controller('PhoneListCtrl', function($scope) {
  $scope.phones = [
    {"name": "Nexus S",
     "snippet": "Fast just got faster with Nexus S."},
    {"name": "Motorola XOOM™ with Wi-Fi",
     "snippet": "The Next, Next Generation tablet."},
    {"name": "MOTOROLA XOOM™",
     "snippet": "The Next, Next Generation tablet."}
  ];
})
.controller('registerCtrl',function($scope){})
.controller('AddCardCtrl',function($scope){})
.controller('111Ctrl',function($scope){})
.controller('productCtrl', function ($scope) {
})

.controller('chanpinCtrl', function ($scope) {

})
.controller('homepageCtrl', function ($scope,Chats, Products) {
     $scope.items = [
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
        $scope.items = Products.all();

     $scope.photoSlides = 0;
})

.controller('actionCtrl', function ($scope) {

})

.controller('nightCtrl', function ($scope) {

})
.controller('111Ctrl', function ($scope) {

})

.controller('222Ctrl', function ($scope) {

})

.controller('cameraTabDefaultPageCtrl', function ($scope) {

})

.controller('cartTabDefaultPageCtrl', function ($scope) {

})

.controller('cloudTabDefaultPageCtrl', function ($scope) {

})
.controller('mybzCtrl', function ($scope) {

})
.controller('CardListCtrl',function($scope){
  $scope.cards = [
    {"bank": "北京银行",
     "number": "4225 **** **** 2548",
        "logo":"img/bj_bank.png"
    },
     {"bank": "广发银行",
     "number": "4225 **** **** 2548",
         "logo":"img/gf_bank.png"},
     {"bank": "招商银行",
     "number": "4235 **** **** 2542",
         "logo":"img/zs_bank.jpg"}
  ];
})
    .controller('ProductDetailCtrl',function($scope){
        $scope.intro = [
            { "name" : "预期年化收益",
                "value" : "9.6%"
            },
            { "name" : "封闭期",
                "value" : "9.6%"
            },
            { "name" : "起息日",
                "value" : "购买之日起1-3天"
            },
            { "name" : "退出日",
                "value" : "封闭期结束后1-3天"
            },
            { "name" : "剩余可投金额",
                "value" : "545,500"
            },
        ];
        $scope.limit = [
            { "name" : "起投金额",
                "value" : "100万"
            },
            { "name" : "单笔最高可投",
                "value" : "10000元"
            }
        ];
    })

    .controller('introCtrl', function ($scope) {

})

.controller('feedbackCtrl', function ($scope) {

})

.controller('beginnerCtrl', function ($scope) {

})

.controller('guaranteeCtrl', function ($scope) {

})

.controller('settingCtrl', function ($scope) {

})

  .controller('moreCtrl', function ($scope) {

  })
  .controller("productCtrl",function($scope){
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
    ]
    var toPlus = 1000;
        var minBuy = 5000;
    $scope.toBuy = 5000;
        $scope.toPlus = function(){
            $scope.toBuy = $scope.toBuy + toPlus;
        }
        $scope.toMinus = function(item){
            $scope.toBuy = $scope.toBuy - toPlus;
            if($scope.toBuy < minBuy)
            {
                $scope.toBuy = minBuy;
            }
        }
    $scope.items = products;
  })
;