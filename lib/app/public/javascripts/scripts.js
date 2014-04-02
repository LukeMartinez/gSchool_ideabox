$(document).ready(function() {
   $('.button').mouseenter(function() {
       $(this).animate({
           height: '+=10px'
       });
   });
   $('button').mouseleave(function() {
       $(this).animate({
           height: '-=10px'
       }); 
   });
});
