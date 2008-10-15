package fr.kfeyn
{
	public class LinearFisheye
	{
		
		private var min:Number;
		private var max:Number;
		
		private var distortPercent:Number;
		private var focusAreaPercent:Number;
		private var focusDist:Number;
		private var realFocusDist:Number;
		
		private var outMin:Number;
		private var outMax:Number;
		
		private var focus:Number;
		
		// const
		private var dstart:Number;
		private var dstop:Number;
		
		private var focustart:Number;
		private var focustop:Number;
		
		private var extended_dstart:Number;
		private var extended_dstop:Number;
		
		private var extended_focustart:Number;
		private var extended_focustop:Number
		
		private var under_dstart:Number;
		private var under_focustart:Number;
		private var under_focustop:Number;		
		private var under_dstop:Number;
		private var total:Number;
		private var freshValues:Boolean;
		
		
		public function LinearFisheye(min:Number, max:Number, outMin:Number, outMax:Number):void
		{
			this.min = min;
			this.max = max;
			this.outMin = outMin;
			this.outMax = outMax;
			this.focus = (max-min)/2;
		}
		
		public function setFocus(focus:Number, focusDist:Number, distortPercent:Number, focusAreaPercent:Number):void {
			this.focus = Math.max(Math.min(focus, max), min);
			
			this.distortPercent = Math.min(Math.max(distortPercent,1),100);
			this.focusAreaPercent = Math.min(this.distortPercent, focusAreaPercent);
			
			this.extended_dstart = this.focus - this.distortPercent/200*(max-min);
			this.extended_dstop = this.focus + this.distortPercent/200*(max-min);
			
			this.extended_focustart = this.focus - this.focusAreaPercent/200*(max-min);
			this.extended_focustop = this.focus + this.focusAreaPercent/200*(max-min);			
			
			this.dstart = Math.max(extended_dstart,min);
			this.dstop = Math.min(extended_dstop, max);
			
			this.focustart = Math.max(extended_focustart,min);
			this.focustop = Math.min(extended_focustop, max);
			
			this.realFocusDist = Math.max(focusDist,0);
			if (this.realFocusDist>0) {
				var estimated:Number = (focustart-extended_dstart)*(this.realFocusDist*100/((max-min)*(this.distortPercent-focusAreaPercent))*(focustart-extended_dstart)) -
									(dstart-extended_dstart)*(this.realFocusDist*100/((max-min)*(this.distortPercent-this.focusAreaPercent))*(dstart-extended_dstart)) +
									(focustop-focustart)*(this.realFocusDist) +
									(dstop-focustop)*(this.realFocusDist*(1-100/((max-min)*(this.distortPercent-this.focusAreaPercent))*(dstop-focustop)));
				this.focusDist = this.realFocusDist * (this.realFocusDist*(max-min)*this.focusAreaPercent/100 + this.realFocusDist*(max-min)*(this.distortPercent-this.focusAreaPercent)/200)/estimated;
			} else 
				this.focusDist = 0;	
						
			freshValues = true;
			total = getRawValue(max);
			freshValues = false;
		}
		
		private function getRawValue(value:Number):Number {
			value = Math.max(Math.min(value, max), min);
			if (value<=dstart) {
				return (value-min);
			} else {
				if (freshValues) {
					under_dstart = dstart-min - (dstart-extended_dstart)*(1+focusDist*100/((max-min)*(distortPercent-focusAreaPercent))*(dstart-extended_dstart)) ;
				}
				if (value<=focustart) {
					return under_dstart + (value-extended_dstart)*(1+focusDist*100/((max-min)*(distortPercent-focusAreaPercent))*(value-extended_dstart));
				} else {
					if (freshValues) {
						under_focustart = under_dstart + (focustart-extended_dstart)*(1+focusDist*100/((max-min)*(distortPercent-focusAreaPercent))*(focustart-extended_dstart));
					}
					if (value<=focustop) {
						return under_focustart + (value-focustart)*(1+focusDist);
					} else {
						if (freshValues) {
							under_focustop = under_focustart + (focustop-focustart)*(1+focusDist);
						}					
						if (value<=dstop) {
							return under_focustop + (value-focustop)*(1+focusDist*(1-100/((max-min)*(distortPercent-focusAreaPercent))*(value-focustop)));
						} else {
							if (freshValues) {
								under_dstop = under_focustop + (dstop-focustop)*(1+focusDist*(1-100/((max-min)*(distortPercent-focusAreaPercent))*(dstop-focustop)));
							}
							return under_dstop + value-dstop;
						}
					}
				}
			}
		}
		
		public function getValue(value:Number):Number {
			return outMin + (outMax-outMin)/total * getRawValue(value);
		}
		
		public function getDOI(value:Number):Number {
			if ((value<min)||(value>max)) return 0;
			if (value<dstart) {
				return 1;
			} else {
				if (value<focustart) {
					return 1 + (value-extended_dstart)/(focustart-extended_dstart)*focusDist;
				} else {
					if (value<=focustop) {
						return 1+focusDist;
					} else {
						if (value<=dstop) {
							return 1+ (extended_dstop-value)/(extended_dstop-focustop)*focusDist;
						} else {
							return 1;
						}
					}
				}
			}
		}
		
		public function getRealDOI(value:Number):Number {
			var rawDoi:Number = getDOI(value);
			return (rawDoi==0)?0:(1+ (rawDoi-1)*realFocusDist/focusDist);
		}
	}
}