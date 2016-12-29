
package com.nri.rui.core.controls
{
public class CalculatorHandlers
{
	// properties
	// object to hold a reference to the view object
	public var calcView:Object;
	// registers to hold temporary values pending operation
	private var reg1:String="";
	private var reg2:String="";
	// result of an operation
	private var result:Number;
	// the name of the register currently used
	private var currentRegister:String="reg1";
	// the name of the next operation to be performed
	private var operation:String="none";
	// for convenience, holder for numerical equivalents 
	// of the register string values
	private var r1:Number;
	private var r2:Number;
	// constructor
	public function CalculatorHandlers()
	{}

	// methods
	// perform the current operation on the 2 registers
	public function doOperation():void
	{
		// cast the register values to numbers
		r1=Number(reg1);
		r2=Number(reg2);
		switch (operation)
		{
			case "add":
				result=r1+r2;
				resetAfterOp();
				break;
			case "subtract":
				result=r1-r2;
				resetAfterOp();
				break;
			case "multiply":		
				result=r1*r2;
				resetAfterOp();
				break;
			case "divide":
				result=r1/r2;
				resetAfterOp();
				break;
			default:
				// do nothing
		}
	}
	// concatenate number to the value of the current register
	public function addNumber(n:String):void
	{
		if (operation=="none" && currentRegister=="reg2")
		{
			reg1="";
			setCurrentRegister();
		}
		this[currentRegister]+=n;
		setDisplay(currentRegister);
	}
	// clear the current register
	public function clearEntry():void
	{
		this[currentRegister]="";
		setDisplay(currentRegister);
	}
	// clear both registers and the current operation
	public function clearAll():void
	{
		reg1="";
		reg2="";
		setCurrentRegister();
		setOperation("none");
		setDisplay(currentRegister);
	}
	// set the current operation
	public function setOperation(operation:String):void
	{
		this.operation=operation;
		setCurrentRegister();
	}
	// set the value shown in the display
	private function setDisplay(register:String):void
	{
		calcView.calcDisplay.text = this[register];
	}
	// set which register is current
	private function setCurrentRegister():void
	{
		if (reg1=="")
		{
			currentRegister="reg1";
		}
		else
		{
			currentRegister="reg2";
		}
	}
	// reset values after an operation
	private function resetAfterOp():void
	{
		reg1=String(result);
		reg2="";
		setDisplay("reg1");
		setOperation("none");
	}
}
}