// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
// 'starter.services' is found in services.js
// 'starter.controllers' is found in controllers.js
angular.module('starter', ['ionic', 'starter.controllers', 'starter.services'])

.run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if (window.cordova && window.cordova.plugins && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      cordova.plugins.Keyboard.disableScroll(true);

    }
    if (window.StatusBar) {
      // org.apache.cordova.statusbar required
      StatusBar.styleDefault();
    }
  });
})

.config(function($stateProvider, $urlRouterProvider, $ionicConfigProvider) {

  // Ionic uses AngularUI Router which uses the concept of states
  // Learn more here: https://github.com/angular-ui/ui-router
  // Set up the various states which the app can be in.
  // Each state's controller can be found in controllers.js
   $ionicConfigProvider.platform.ios.tabs.style('standard'); 
        $ionicConfigProvider.platform.ios.tabs.position('bottom');
        $ionicConfigProvider.platform.android.tabs.style('standard');
        $ionicConfigProvider.platform.android.tabs.position('standard');

        $ionicConfigProvider.platform.ios.navBar.alignTitle('center'); 
        $ionicConfigProvider.platform.android.navBar.alignTitle('center');

        $ionicConfigProvider.platform.ios.backButton.previousTitleText('').icon('ion-ios-arrow-thin-left');
        $ionicConfigProvider.platform.android.backButton.previousTitleText('').icon('ion-android-arrow-back');        

        $ionicConfigProvider.platform.ios.views.transition('ios'); 
        $ionicConfigProvider.platform.android.views.transition('android');


  // Ionic uses AngularUI Router which uses the concept of states
  // Learn more here: https://github.com/angular-ui/ui-router
  // Set up the various states which the app can be in.
  // Each state's controller can be found in controllers.js
  $stateProvider

  // setup an abstract state for the tabs directive
    .state('tab', {
    url: '/tab',
    abstract: true,
    templateUrl: 'templates/tabs.html'
  })

  // Each tab has its own nav history stack:

  .state('tab.dash', {
    url: '/dash',
    views: {
      'tab-dash': {
        templateUrl: 'templates/tab-dash.html',
        controller: 'DashCtrl'
      }
    }
  })
      .state('welcome',{
          url: '/welcome',
          templateUrl: 'templates/welcome.html'
      })
  .state('tab.account', {
      url: '/account',
      views: {
        'tab-login': {
          templateUrl: 'templates/tab-account.html',
          controller: 'AccountCtrl'
        }
      }
    })

  .state('tab.add-card', {
      url: '/add-card',
      views: {
        'tab-login': {
          templateUrl: 'templates/tab-add-card.html',
          controller: 'AddCardCtrl'
        }
      }
    })
  .state('tab.card-list', {
      url: '/card-list',
      views: {
        'tab-login': {
          templateUrl: 'templates/tab-card-list.html',
          controller: 'CardListCtrl'
        }
      }
    })
  .state('tab.chats', {
      url: '/chats',
      views: {
        'tab-chats': {
          templateUrl: 'templates/tab-chats.html',
          controller: 'ChatsCtrl'
        }
      }
    })
    .state('tab.chat-detail', {
      url: '/chats/:chatId',
      views: {
        'tab-chats': {
          templateUrl: 'templates/chat-detail.html',
          controller: 'ChatDetailCtrl'
        }
      }
    })
   .state('tab.instruction', {
      url: '/instruction',
      views: {
        'tab-chats': {
          templateUrl: 'templates/instruction.html',
          controller: 'ChatDetailCtrl'
        }
      }
    }) 
  .state('tab.login', {
    url: '/login',
    views: {
      'tab-login': {
        templateUrl: 'templates/tab-login.html',
        controller: 'LoginCtrl'
      }
    }
  })
  .state('tab.111', {
        url: '/111',
        views:{
          'tab-register':{
            templateUrl: 'templates/tab-register.html',
            controller: '111Ctrl'    
          }
        }       
    })
  .state('tab.register', {
        url: '/register',
        views:{
          'tab-login':
          {
              templateUrl: 'templates/tab-register.html',
              controller: 'registerCtrl'    
          }
        }
        
    })
      .state('tab.product', {
          url: '/product',
          views:{
              'tab-product':
              {
                  templateUrl: 'templates/tab-product.html',
                  controller: 'productCtrl'
              }
          }

      })
      .state('tab.product-detail', {
          url: '/product-detail',
          views:{
              'tab-product':
              {
                  templateUrl: 'templates/tab-product-detail.html',
                  controller: 'productCtrl'
              }
          }

      })
    .state('chanpin', {
        url: '/page17',
        templateUrl: 'templates/chanpin.html',
        controller: 'chanpinCtrl'
    })
    .state('tab.homepage', {
        url: '/homepage',
        views: {
            'tab-homepage':
             {
                 templateUrl: 'templates/homepage.html',
                 controller: 'homepageCtrl'
             }
        }
    })
      .state('tab.guarantee', {
          url: '/guarantee',
          views: {
             'tab-more': {
                 templateUrl: 'templates/guarantee.html',
                 controller: 'homepageCtrl'
             }

          }

      })
      .state('tab.product-detail-more', {
          url: '/product-detail-more',
          views: {
              'tab-product': {
                  templateUrl: 'templates/tab-product-more.html',
                  controller: 'ProductDetailCtrl'
              }

          }

      })
      .state('tab.bank-list', {
          url: '/bank-list',
          views: {
              'tab-product': {
                  templateUrl: 'templates/tab-bank-list.html',
                  controller: 'ProductDetailCtrl'
              }

          }

      })
      .state('tab.feedback', {
          url: '/feedback',
          views: {
              'tab-more': {
                  templateUrl: 'templates/feedback.html',
                  controller: 'moreCtrl'
              }

          }

      })
      .state('tab.company', {
          url: '/company',
          views: {
              'tab-more': {
                  templateUrl: 'templates/company.html',
                  controller: 'moreCtrl'
              }

          }

      })
      .state('action', {
        url: '/action',
        templateUrl: 'templates/action.html',
        controller: 'actionCtrl'
    })





    .state('night', {
        url: '/night',
        templateUrl: 'templates/night.html',
        controller: 'nightCtrl'
    })
    .state('tab.more', {
        url: '/more',
        views: {
            'tab-more':
            {
                templateUrl: 'templates/tab-more.html',
                controller: 'moreCtrl'
            }
        }
    })
    .state('111', {
        url: '/111',
        templateUrl: 'templates/111.html',
        controller: '111Ctrl'
    })





    

    .state('feedback', {
        url: '/feedback',
        templateUrl: 'templates/feedback.html',
        controller: 'feedbackCtrl'
    })





    .state('beginner', {
        url: '/beginner',
        templateUrl: 'templates/beginner.html',
        controller: 'beginnerCtrl'
    })





    .state('guarantee', {
        url: '/guarantee',
        templateUrl: 'templates/guarantee.html',
        controller: 'guaranteeCtrl'
    })





    .state('setting', {
        url: '/setting',
        templateUrl: 'templates/setting.html',
        controller: 'settingCtrl'
    })
  ;

  // if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise('/tab/homepage');

});
