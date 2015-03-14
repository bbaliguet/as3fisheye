# Introduction #

The linear fisheye provides a fisheye projection based on Bederson's linear Degree of Interest function (Bederson, 2000). The Degree of Interest, DOI, is a function that describes the importance of an element compared to a "focussed" element. According to this function, the position of the elements around the focus element are determined.

This implementation allows an appropriate repartition of the entry values on the output range (for example, no "return" effect on the border, and a constant space repartition of the value). An example can be found here: [example](http://2ndfondation.nuxit.net/projects/as3fisheye/FisheyeProject.html).

# Public Methods #

` LinearFisheye(min:Number, max:Number, outMin:Number, outMax:Number):void `
Creates a linear fisheye.

  * _min, max:_ the range for the input values.
  * _outMin, outMax:_ the range for the output values. Typically, the position of a "fisheyed" element in a list.


` setFocus(focus:Number, focusDist:Number, distortPercent:Number, focusAreaPercent:Number):void `
Set the focussed value of the fisheye.

  * _focus:_ the focussed value.
  * _focusDist:_ the distortion of the focus area.
  * _distortPercent:_ the percentage of the total range that will be distorted.
  * _focusAreaPercent:_ the percentage of the total range that will be the focussed area.

` getValue(value:Number):Number `
Get a projected value, according to the fisheye parameters.

  * _value:_ the projected value.


` getRealDOI(value:Number):Number `
Get the Degree of interest of a specific value.

  * _value:_ the projected value.


# References #

Bederson, B. B. (2000). Fisheye Menus. Proceedings of ACM Conference on User Interface Software and Technology (UIST 2000) (pp. 217-226). ACM Press.