//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
/*

	objx core library
	Copyright (c) 2009 - 2010  Mat Ryer
	
	Contributors:
		Mat Ryer, Edd Grant, Simon Howard
	
	http://objx.googlecode.com/ - (See below for version number)
	 
	Permission is hereby granted, free of charge, to any person obtaining
	a copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	
*/

var

	// define root namespace
	objx = function(o) {

		// if this is already an objx object just return it
		if (o && o._objx) {
			return o;
		}
		
		// create new object
		return new objx.fn.init(o);
		
	},

	/*
	 *  debug
	 *  if 'true' (default), performs additional error checking
	 *	to assist development.  This can be set to 'false' for production
	 *  and will provide slight performance enhancements.
	 */ 
	ODebug = true,
	
	/*
	 *  behaviour flags - used for optimisation
	 */
	OAlwaysRememberBoundSource = false,

	// current version
	OVersion = "2.3.6",
	
	// OAction constant modifiers
	ONew = "ONew", 
	OReplace = "OReplace", 
	OUnwrap = "OUnwrap", 
	OOriginal = "OOriginal",
	
	// keep track of plugins
	OPlugins = {}
	
;

/*
 *  OConsole
 *  Writes an item (or array of items) out to the console.
 *
 *  OConsole( obj );
 *  OConsole( [obj1, obj2] );
 *
 */
var OConsole = function(o) {
	
	if (typeof console !== "undefined") {
		if (console) {
			console.warn(" ");
			objx(OArray(o)).each(function(obj){
				if (typeof obj === "string") {
					console.info("objx: " + obj);
				} else {
					console.info(obj);
				}
			});
		}
	}
	
};

/*
 *  OArgArray
 *  Converts 'arguments' inside a function into an actual array
 *
 *	var args = OArgArray(arguments);
 *
 */
var OArgArray = function(args) {

	var a = [];
	
	// collect all arguments
	a.push.apply(a, args);
	
	return a;
	
};

/*
 *  OTrimOffFirstArg
 *  Trims off the first argument and returns the rest
 */
var OTrimOffFirstArg = function(args){

	var a = OArgArray(args);
	a.splice(0, 1);

	// return the array
	return a;
};

/*
 *  OError
 *  Just throws an error
 *
 *  OError( message )
 *  OError( tag, message )
 */
var OError = function() {

	// the last thing is the message
	var 
		tag = arguments.length > 1 ? arguments[0] : "Error",
		message = arguments[arguments.length - 1]
	;
	
	throw tag + ": " + message;
	
};


/*
 *  OType
 *  Gets the type of object
 *
 *	OType( object )
 *
 */
var OType = function(o) {

	var kind;
	
	if (o !== null && typeof o !== "undefined") {
		kind = typeof o;
		if (kind === "object") {
			if (typeof o.length !== "undefined") {
				kind = "array";
			} else if (o._objx) {
				kind = "objx";
			}
		}
	} else {
		kind = "null";
	}
	
	return kind;
		
};


/*
 *  OExtend
 *  extends the first object with the others and returns the newly
 *  extended object.
 *
 *  OExtend(destination, source1 [, source2 [, source3]]);
 *  
 *  destination		-	The target object (everything will be copied
 *							into this object)
 *  sourceX			-	These objects will have their properties, functions
 *							etc. copied to 'destination'
 *  
 */
var OExtend = function() {
	
	if (ODebug) {
		if (arguments.length < 2) {
			OError("OExtend", "Must provide at least two arguments when using OExtend(). See http://code.google.com/p/objx/wiki/extend");
		}
	}
	
	var i, property;
	
	for (i = 1; i < arguments.length; i++) {
		
		for (property in arguments[i]) {
			if (arguments[i].hasOwnProperty(property)) {
				arguments[0][property] = arguments[i][property];
			}
		}
		
		// explicitly handle toString for lovely IE
		/*@cc_on

			if(arguments[i].toString !== Object.prototype.toString){
			  arguments[0].toString = arguments[i].toString;
			}
			if(arguments[i].valueOf !== Object.prototype.valueOf){
			  arguments[0].valueOf = arguments[i].valueOf;
			}
			
		@*/
		
	}
	
	return arguments[0];
	
};

/*
 *  ORequires
 *  Indicates that a plugin is required and throws an error if it is not included
 *
 *  ORequires( source, plugin )
 *
 *  plugin	-	The name of the plugin that is required
 *  source	-	(optional) A name describing the plugin that requires this other plugin
 *
 */
var ORequires = function(plugin, source) {

	// has this been provided?
	if (!OPlugins[plugin]) {
		var byText = source ? "by \"" + source + "\" " : "";
		OError("requires", "Plugin \"" + plugin + "\" is required " + byText + "but missing. Are you missing a <script /> tag?  Have you got your <script /> tags in the wrong order?");
	}
	
	return this;
		
};

/*
 *  OProvides
 *  Indicates that a plugin is being provided
 *
 *	OProvides( plugin )
 *
 *	plugin - A unique name describing the plugin
 *
 */
var OProvides = function(plugin) {

	// has this already been provided?
	if (OPlugins[plugin]) {
		OError("provides", "A plugin called \"" + plugin + "\" has already been provided. Have you duplicated a <script /> tag?");
	}
	
	// save the fact that this has been provided
	OPlugins[plugin] = true;
	
};


/*
 *  OProvided
 *  Gets whether a plugin has been provided or not
 */
var OProvided = function(plugin) {
	return OPlugins[plugin] || false;
};


// the root object
objx.fn = objx.prototype = {

	// object marker
	_objx: true,


	// actual object
	_obj: null,


	// initialization function
	init: function(obj) {
	
		// save the object
		this.obj(obj);
		
		// save the type
		this.kind = OType(obj);
		
	},
	
	
	/*
	 *  extend
	 *  Extends the selected object 
	 */
	extend: function() {
	
		var args = [], i = 0;
		
		// add the first argument
		args.push(this._obj);
		
		// add the other arguments
		for (; i < arguments.length; i++) {
			args.push(arguments[i]);
		}
	
		// call the extender
		OExtend.apply(objx, args);
	
		// return this for chaining
		return this;
	
	},
	
	/*
	 *  obj()
	 *  Gets or sets the object that is being enhanced
	 *
	 *		objx(obj).obj() == obj
	 *		objx(obj).obj(obj2)
	 *
	 */
	obj: function() {
		if (arguments.length === 0) {
			return this._obj;
		} else {
			this._obj = arguments[0];
			
			// save the type
			this.kind = OType(this._obj);
			
		}
		return this;
	},
	
	
	/*
	 *  size()
	 *  Gets the size of the object.
	 */
	size: function() {
	
		if (this.kind !== "number" && typeof this._obj.length === "undefined") {
			OError("size", "Cannot get the size of " + this.kind + "s.");
		}
		
		return this._obj.length || this._obj;
	},
	
	/*
	 *  toString()
	 *  Gets a string representing this object - to make debugging easier
	 */
	toString: function() {
		
		var 
			type = this.kind,
			val = this._obj.toString()
		;
		
		switch (type) {
			case "string":
				val = '"' + val + '"';
				break;
			case "function":
				val = " ... ";
				break;
			case "array":
			
				var size = this.size();
				
				if (size === 0) {
					val = "0";
				} else {
					val = " 0.." + (size - 1) + " ";
				}
				
				break;
		}
		
		return "objx:(" + type + "(" + val + "))";
	},
	

	/*
	 *  requires
	 *  Instance version of ORequires
	 *
	 *  Allows objx("Source").requires("item1", "item2").requires("item3");
	 *
	 */
	requires: function() {

		for (var i = 0, l = arguments.length; i<l; i++) {
			ORequires(arguments[i], this.obj());
		}
		
		return this;

	}
	
};


// setup easy construction
objx.fn.init.prototype = objx.fn;


/*
 *  OIsObjx
 *  checks whether an object is an objx object or not
 *
 *  OIsObjx( object-to-test )
 *
 */
var OIsObjx = function(o) {
	if (o && o._objx) {
		return true;
	}
	return false;
};


/*
 *  OBind
 *  Binds context and arguments to a function
 *
 *  js.bind(function, context [, argument1 [, argument2]]);
 */
var OBind = function() {

	var 
	
		_func = arguments[0] || null,
		_obj = arguments[1] || this,
		_args = [],
		
		i = 2, 
		l = arguments.length,
		
		bound
		
	;
	
	// add arguments
	for (; i<l; i++) {
		_args.push(arguments[i]);
	}
	
	// return a new function that wraps everything up
	bound = function() {
		
		// start an array to get the args
		var theArgs = [];
		var i = 0;

		// add every argument from _args
		for (i = 0, l = _args.length; i < l; i++) {
			theArgs.push(_args[i]);
		}
		
		// add any real arguments passed
		for (i = 0, l = arguments.length; i < l; i++) {
			theArgs.push(arguments[i]);
		}

		// call the function with the specified context and arguments
		return _func.apply(_obj, theArgs);

	};
	
	if (ODebug || OAlwaysRememberBoundSource) {
		bound.func = _func;
		bound.context = _obj;
		bound.args = _args;
	}
	
	return bound;
	
};

/*
 *  instance shortcut version...
 */
Function.prototype.bind = function(){
	
	var theArgs = [], i = 0, l = arguments.length;
	
	// add the function
	theArgs.push(this);
	
	// add any real arguments passed
	for (; i < l; i++) {
		theArgs.push(arguments[i]);
	}
	
	return OBind.apply(window, theArgs);
	
};

/*
 *  OAction
 *
 *	Creates an objx Action
 *
 */
var OAction = function(name, options){

	var _options = options, _name = name;
	
	if (options.requires) {
		
		// make sure we have all the capabilities we require
		objx(OArray(options.requires)).each(function(plugin){
			ORequires(plugin, "OAction(\"" + name + "\")");
		});
		
	}
	
	objx.fn[name] = function(){
		
		var 
			actor,
			argX = arguments[arguments.length-1], // get the last argument
			args = OArgArray(arguments), // trim off the first argument
			result
		;
		
		if (args.length > 0 && (argX instanceof Function || argX === OOriginal || argX === ONew || argX === OReplace || argX === OUnwrap)) {
		
			// lose the last argument - it's not interesting to the action behaviour method
			args.pop();
			
		}
		
		if (_options.collective) {
		
			result = [];
			
			// create a new arguments array
			var sArgs = 
			
				// add placeholders for object and index (these will be overwritten
				// in the .each method)
				[null, null]
			
				// add the args passed into this action (when it was called by the user)
				.concat(args);
			
			this.each(function(o,i){
			
				// get the actor for this kind of object	
				actor = _options[OType(o)] || _options.all || OError("." + _name + "() does not support " + OType(o) + "s.  Are you working with the wrong type?  Check objx(o).kind to be sure.");
				
				// set the specific arguments for this call
				sArgs[0] = o; sArgs[1] = i;
				
				// make the call and save the result
				result.push(actor.apply(this, sArgs));
				
			});
		
		} else {
		
			actor = _options[this.kind] || _options.all || OError("." + _name + "() does not support " + this.kind + "s.  Are you working with the wrong type?  Check objx(o).kind to be sure.");
		
			// call the action behaviour callback
			result = actor.apply(this, args);
		
		}
	
		// handle the result
		if (argX instanceof Function) {
		
			argX.apply(this, [result]);
			return this;
			
		} else {
		
			var action = _options.action || OUnwrap, userAction;
			if (argX === ONew || argX === OReplace || argX === OUnwrap || argX === OOriginal) { userAction = action = argX; }
		
			if (typeof result == "undefined") {
			
				if (userAction === OUnwrap) {
					result = this.obj();
				} else {
					result = this;
				}

			}
			
			switch (action) {
				case OOriginal:
					return this;
				case ONew:
					return objx(result);
				case OReplace:
					return this.obj(result);
				default:
					return result;
			}
						
		}
		
	};

};

/*
 *  OGet
 *
 *  Gets a value from an object
 *
 */
var OGet = function(obj, prop) {

	var wasString = false;
	
	//If the input is a String then convert it to an Array.
	if (typeof obj == "string" && typeof prop != "function") {
		obj = obj.split("");
		wasString = true;
	}

	switch (typeof prop) {
		case "function":
			return prop.apply(this, [obj]);
		case "number":

			if (typeof obj === "string") {
				return obj.substr(OIndex(prop, obj.length), 1);
			} else {
				return obj[OIndex(prop, obj.length)];
			}
		break;

		case "string":

			var bracket = prop.toString().indexOf("[");
			
			if (bracket != -1) {

				// transform the brackets into dot notation
				prop = prop
					.replace("['", ".")
					.replace("[", ".")
					.replace("[\"", ".")
					.replace("']", "")
					.replace("]", "")
					.replace("\"]", "")
				;

			}
			
			var dotPos = prop.toString().indexOf(".");
			
			if (dotPos == -1 && bracket == -1) {
				return obj[prop];
			}
			else {
				return OGet(obj[prop.substring(0, dotPos)], prop.substring(dotPos + 1));
			}
			
		break;

		case "object":
			if(prop.length) {

				var 
				  result = [],
				  startIndex = OIndex( prop[0], obj.length ),
				  endIndex = OIndex( prop[1], obj.length )
				;

				if(startIndex <= endIndex) {
					for(i = startIndex; i <=  endIndex; i++) {
						result.push(obj[i]);
					}
				}
				else {
					for(i = startIndex; i >=  endIndex; i--) {
						result.push(obj[i]);
					}
				}

        if (wasString) {
          return result.join("");
        } else {
          return result;
        }
        
			}
		break;
	}

  OError("OGet", "OGet doesn't support that combination of parameters.");

};

/*
 *  .get() action
 *
 *	Provides OGet functionality as an instance method/action
 *
 */
OAction("get", {
	action: OUnwrap,
	all: function(what) {
		return OGet(this._obj, what);
	}
});


/*
 *  OCheck
 *
 *  Compares rules against an object and returns the result
 *  see http://code.google.com/p/objx/wiki/OCheck
 *
 */
var OCheck = function(o, c) {

	var prop, val, oval, comp, comps = OCheck.comparers, passed = true;
	
	if (c instanceof Function) {
	
		if (!c(o)) {
			passed = false;
		}
	
	} else if (c instanceof Object) {
		
		for (prop in c) {
			if (c.hasOwnProperty(prop)){
				
				var dealt = false;
				for (comp in comps) {
					if (prop == comp) {
						dealt = true;
						if (!comps[comp](o, c[prop])) {
							passed = false;
						}
					}
				}
				
				if (!dealt) {
				
					// assume it's a field name
					oval = OGet(o, prop);
					
					if (typeof oval !== "undefined") {
	
						dealt = true;
						val = c[prop];
						
						switch (OType(val)) {
							case "object": // complex object
								if (!OCheck(oval, val)) { passed = false; }
								break;
							case "array": // or array
								
								var orPassed = false;
								objx(val).each(function(orVal){
									if (OCheck(oval, orVal)) {
										orPassed = true;
										return false;
									}
								});
								
								if (!orPassed) {
									passed = false;
								}
								
								break;
							case "function": // callback delegate
								if (!val(oval, o)) { passed = false; }
								break;
							default: // normal equality
								if (!OCheck.comparers.eq(oval, val)) { passed = false; }
						}
						
					}
					
				}
				
				if (!dealt) {
					OError("OCheck", "Unknown comparer token \"" + prop + "\".  It's not in OCheck.comparers nor is it a field name in the object being checked.  Are you calling this before including the right <script /> tag?  Have you mispelled the field name?");
				}
			
			}
		}
		
	} else {
		if (!OCheck.comparers.eq(o, c)) { passed = false; }
	}
	
	return passed;
	
};

/*
 *  An object containing comparer commands
 */
OCheck.comparers = {
	
	// equality
	eq: function(o, c) {
		return o == c;
	},
	eqs: function(o, c) {
		return o === c;
	},
	
	// negative comparer
	isnt: function(o, c) {
		return !OCheck(o, c);
	},
	
	// comparasons
	gt: function(o, c) {
		return o > c;
	},
	eqgt: function(o, c) {
		return o >= c;
	},
	lt: function(o, c) {
		return o < c;
	},
	eqlt: function(o, c) {
		return o <= c;
	},
	isType: function(o, c) {
		return typeof o === c;
	}
	
};

// OCheck comparer aliases
OCheck.comparers.above = OCheck.comparers.gt;
OCheck.comparers.below = OCheck.comparers.lt;
OCheck.comparers.is = OCheck.comparers.eq;
OCheck.comparers.not = OCheck.comparers.isnt;

/*
 *  .check
 *  Provides OCheck functionality against objx instances
 */
OAction("check", {
	all: function(c) {
		return OCheck(this.obj(), c);
	}
});

/*
 *  OIndex
 *  Gets the real index from magic index values (i.e can be negative)
 *  
 */
var OIndex = function(i, l) {
	return (i > -1) ? i : (l + (i));
};


/*
 *  OIndexRange
 *  Gets the real index range from magic index values (i.e. can be negative)
 */
var OIndexRange = function(s, e, len) {
	
	var range = {};
	
	// resolve any magic indexes (i.e. negative numbers)
	range.start = OIndex(s, len);
	if (e) {
		range.end = OIndex(e, len);
	} else if (s < 0) {
		range.end = len - 1;
	} else {
		range.end = range.start;
	}
	
	// make sure they're the right way around
	if (s && e) {
	
		s = Math.min(range.start, range.end);
		e = Math.max(range.start, range.end);
	
		range.start = s;
		range.end = e;
	
	}
	
	return range;
	
};

/*
 *  (boolean) OIndexRangeIsBackwards
 *  Helper method to see if an index range is going backwards or not
 */
var OIndexRangeIsBackwards = function(r, len) {
  return OIndex(r[0], len) > OIndex(r[1], len);
}

/*
 *  OArray
 *  Ensures that an object is an array
 *
 *	(array) OArray( object );
 *
 */
var OArray = function(o){
	
	if (OType(o) != "array") {
		return [o];
	} else {
		return o;
	}
	
};



/*
 *  objx.toString
 *  Gets a string representation of this object to make debugging easier.
 */
objx.toString = function() {
	return "{objx engine}";
};

/*
 *  PREINSTALLED PLUGINS
 */
 
 
/*
 *  each
 *  Mat Ryer
 *
 *  Calls a function for each item in an object
 *
 */
objx.fn.each = function() {

  var 
    obj = this.obj(), 
    i = 0, 
    e, 
    callback = arguments[arguments.length-1],
    modifier = arguments[0],
    backwards = false
  ;
	
	if (ODebug) {
    if (!(callback instanceof Function)) {
      OError("objx.each", "Last argument to .each() must be a callback function.  " + typeof callback + " is not allowed.");
    }
	}
	
	if (typeof modifier === "object") {
	  if (OIndexRangeIsBackwards(modifier, this.size())) {
	    backwards = true;
	  }
	}
	
	if (modifier === true || backwards === true) {

		/*
		 *  BACKWARDS
		 */
		switch (this.kind) {
			case "string":
				i = this.size();
				// handle strings explicitly
				for (; i--;) {
					if (callback.apply(this, [obj.charAt(i), i]) === false) {
						break;
					}
				}
				break;
				
			case "number":
				
				i = this.size();

				// call each for every number
				if (i > 0) {
					for (; i--;) {
						if (callback.apply(this, [i+1, i]) === false) {
							break;
						}
					}
				} else {
					e = -1;
					for (; i<=e; e--) {
						if (callback.apply(this, [e, 0-e-1]) === false) {
							break;
						}
					}
				}
				
				break;
				
			case "array":
			
				i = this.size();
				// handle array like objects
				for (; i--;) {
					if (callback.apply(this, [obj[i], i]) === false) {
						break;
					}
				}
				break;
				
			default:
			
				// handle every other kind of object
				for (var prop in obj) {
					if (callback.apply(this, [obj[prop], prop]) === false) {
						break;
					}
				}
				
		}

	} else {
	
		/*
		 *  FORWARDS
		 */
    if (this.kind !== "object") {
      e = this.size();
    }
      
	  if (typeof modifier == "object") {
	    // index range
	    
	    i = OIndex(modifier[0], e);
	    e = OIndex(modifier[1], e)+1;

	  }
	 
    switch (this.kind) {
			case "string":
			
				// handle strings explicitly
				for (; i < e; i++) {
					if (callback.apply(this, [obj.charAt(i), i]) === false) {
						break;
					}
				}
				break;
				
			case "number":
				
				if (e > 0) {
					// call each for every number
					for (; i < e; i++) {
						if (callback.apply(this, [i+1, i]) === false) {
							break;
						}
					}
				} else {
					i = e;
					for (; i++;) {
						if (callback.apply(this, [i-1, i-e-1]) === false) {
							break;
						}
					}
				}
				break;
				
			case "array":
			
				// handle array like objects
				for (; i < e; i++) {
					if (callback.apply(this, [obj[i], i]) === false) {
						break;
					}
				}
				break;
				
			default:
			
				// handle every other kind of object
				for (var prop in obj) {
					if (callback.apply(this, [obj[prop], prop]) === false) {
						break;
					}
				}
				
		}
		
	}

    return this;
        
};
