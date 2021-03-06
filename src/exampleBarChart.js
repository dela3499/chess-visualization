
    (function() {
        // define dimensions of svg
        var h = 400;
        var w = 800;
        var chartPadding = 50;
        var chartBottom = h - chartPadding;
        var chartRight = w - chartPadding;

        // create svg element
        var chart = d3.select('#example10')
                      .append('svg')
                      .attr('width', w)
                      .attr('height', h);

        // load data from a CSV file
        d3.csv('data/homesales2010.csv', function(d) {
                return {
                    key: d.state,
                    value: +d.value
                };
            },
            function(dataset){

                var barLabels = dataset.map(function(datum){
                    return datum.key;
                });

                var maxValue = d3.max(dataset,function(d){ return d.value; });

                var sortDir = 'asc'; 

                // set up scales
                var yScale = d3.scale
                               .linear()
                               .domain( [0,maxValue] )
                               .range( [chartBottom,chartPadding] )
                               .nice();

                var xScale = d3.scale.ordinal()
                               .domain(barLabels)
                               .rangeRoundBands([chartPadding,chartRight], 0.1);
                                // divides bands equally among total width, with 10% spacing.

                var yAxis = d3.svg.axis()
                                  .scale(yScale)
                                  .orient('left')
                                  .ticks(5);

                var xAxis = d3.svg.axis()
                                  .scale(xScale)
                                  .orient('bottom')
                                  .tickSize(0);

                d3.select('button#sortButton3') // add listener to button to activate sorting
                  .on('click',function(){
                        sortChart();
                  });

                // create bars
                chart.selectAll('rect')
                   .data(dataset)
                   .enter()
                   .append('rect')
                   .attr({
                        'x': function(d,i) {
                            return xScale(d.key);
                        },
                        'y': function(d) {
                            return yScale(d.value);
                        },
                        'width': xScale.rangeBand(),
                        'height': function(d) {
                            return chartBottom - yScale(d.value);
                        },
                        'fill': 'red'
                    })
                   .on('mouseover',function(d){
                        d3.select(this)
                          .attr('fill','yellow');
                          showValue(d);
                   })
                   .on('mouseout',function(d){
                        d3.select(this)
                          .transition()  // adds a "smoothing" animation to the transition
                          .duration(500) // set the duration of the transition in ms (default = 250)
                          .attr('fill','red');
                          hideValue();
                    });

                var y_axis = chart.append('g')
                                  .attr('class','axis')
                                  .attr('transform','translate(' + chartPadding + ',0)');

                yAxis(y_axis);

                x_axis = chart.append('g')
                     .attr('class', 'axis xAxis')
                     .attr('transform','translate(0,' + chartBottom + ')')  // push to bottom
                     .call(xAxis) // passes itself (g element) into xAxis function
                     // rotate tick labels
                     .selectAll('text')
                        .style('text-anchor','end')
                        .attr('transform','rotate(-65)');

                var showValue = function(d) {
                    chart.append('text')
                         .text(d.value)
                         .attr({
                             'x': xScale(d.key) + xScale.rangeBand() / 2,
                             'y': yScale(d.value) + 15,
                             'class': 'value'
                         });
                }

                var hideValue = function() {
                    chart.select('text.value').remove();
                }

                var sortChart = function() {
                    var newDomain = [];  // declare array to hold re-ordered ordinal domain for xScale
                    chart.selectAll('rect')
                         .sort(function(a,b) {
                              if( sortDir == 'asc' ) {
                                  return d3.ascending(a.value,b.value);       
                              } else {
                                  return d3.descending(a.value,b.value);
                              }
                         })
                         .transition()
                         .delay(function(d,i){   // add a delay() call before duration() call
                             return i * 50;
                             //return (i/dataset.length) * 1000;
                         })
                         .duration(1000)
                         .attr('x',function(d,i){
                              return xScale(i);  // re-position bars based on sorted positions
                         })
                         .attr('fill',function(d){
                              return 'rgb(' + (d.value/maxValue * 255) + ',0,0)'; //  r of 0 - 255
                         });

                    chart.selectAll('rect')
                         .each(function(d){
                            newDomain.push( d.key );
                         });

                    xScale.domain( newDomain );

                    chart.select('.axis.xAxis')
                       .transition()
                       .duration(1000)
                       .call(xAxis)
                       .selectAll('text')
                       .style('text-anchor','end');

                    sortDir = sortDir == 'asc' ? 'desc' : 'asc'; // flip the flag
                }
            }
        );
    })();
    