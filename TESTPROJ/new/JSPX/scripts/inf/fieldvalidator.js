//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
// Numeric only control handler
jQuery.fn.ForceNumericOnly =
function()
{
    return this.each(function()
    {
        $(this).keydown(function(e)
        {
            var key = e.charCode || e.keyCode || 0;
            // allow backspace, tab, enter, delete, arrows, numbers and keypad numbers ONLY
            return (
                key == 8 || 
                key == 9 || 
                key == 13 ||
                key == 46 ||
                (key >= 37 && key <= 40) ||
                (key >= 48 && key <= 57) ||
                (key >= 96 && key <= 105));
        });
    });
};
