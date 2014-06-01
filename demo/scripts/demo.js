'use strict';

var DemoController = function ($scope, $http) {
    $scope.endpoint = 'http://utility.utensils.io:9000/barcodes'
    $scope.symbologies = [
      { name: 'Bookland', value: 'bookland' },
      { name: 'Code 128', value: 'code128' },
      { name: 'Code 25 Interleaved 2 of 5', value: 'code25interleaved' },
      { name: 'Code 25 Non-interleaved 2 of 5', value: 'code25' },
      { name: 'Code 39', value: 'code39' },
      { name: 'Code 93', value: 'code93' },
      { name: 'EAN-13', value: 'ean13' },
      { name: 'EAN-8', value: 'ean8' },
      { name: 'IATA', value: 'iata' },
      { name: 'QR Code', value: 'qr' },
      { name: 'UPC/EAN Supplemental 2', value: 'supp2' },
      { name: 'UPC/EAN Supplemental 5', value: 'supp5' },
      { name: 'UPC-A', value: 'upca' }
    ];
    $scope.formats = ['svg', 'png', 'gif', 'jpg'];
    $scope.errorMessage = '';
    $scope.postData = {
      format: $scope.formats[0],
      data: '',
      encoding: $scope.symbologies[0].value
    };
    $scope.barcodeURL = null;
    $scope.responseData = null;
    $scope.submit = function(){
      $scope.errorMessage = null;
      $scope.barcodeURL = 'images/spinner.gif';
      $http({method: 'POST', url: $scope.endpoint, params: $scope.postData}).
        success(function (data){
          $scope.responseData = data;
          $scope.barcodeURL = data.location;
        }).
        error(function (data){
          $scope.responseData = data;
          $scope.errorMessage = data.error;
          $scope.barcodeURL = null;
        });
    };
  };
