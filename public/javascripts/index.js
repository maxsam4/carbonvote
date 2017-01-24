function createChart(data) {
  Highcharts.chart('CarbonvoteChart', {
    chart: {
      type: 'pie'
    },
    credits: {
      enabled: false
    },
    title: {
      text: 'Vote Status'
    },
    subtitle: {
      text: 'Click the slices to view details.'
    },
    plotOptions: {
      series: {
        dataLabels: {
          enabled: true,
          format: '{point.name}: {point.y:.1f}%'
        }
      }
    },
    tooltip: {
      headerFormat: '<span style="font-size:11px">{point.key}</span><br>',
      pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    },
    series: [{
      name: 'Precentage',
      colorByPoint: true,
      data: [{
        name: 'Vote YES',
        y: data.yes_precentage,
        drilldown: 'Vote YES'
      }, {
        name: 'Vote NO',
        y: data.no_precentage,
        drilldown: null
      }]
    }],
    drilldown: {
      series: [{
        name: 'Precentage',
        id: 'Vote YES',
        data: data.yes_drilldown
      }]
    },
    colors: ['#99CC66', '#FF6666', '#333', '#CB2326', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#CB2326']
  });
}

function ajaxLoad(url, callback) {
  var xmlhttp = new XMLHttpRequest();

  xmlhttp.onreadystatechange = function() {
    if (xmlhttp.readyState == XMLHttpRequest.DONE ) {
      if (xmlhttp.status == 200) {
        callback(xmlhttp.responseText)
      }
      else if (xmlhttp.status == 400) {
        console.log('There was an error 400');
      }
      else {
        console.log('something else other than 200 was returned');
      }
    }
  }

  xmlhttp.open("GET", url, true);
  xmlhttp.send();
}

(function() {
  ajaxLoad('/vote', function(res) {
    createChart(JSON.parse(res))
  })
})()
