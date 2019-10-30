# octave-hgsetget
A class for Octave used to derive handle class with set and get methods

HGSETGET   HG-style set and get for MATLAB objects.

  The HGSETGET class is an abstract class that provides an Handle Graphics-style
  property set and get interface.  HGSETGET is a subclass of HANDLE, so 
  any classes derived from HGSETGET are handle classes.


  ```classdef myclass < hgsetget``` makes ```myclass``` a subclass of
  HGSETGET.

  Classes that are derived from HGSETGET inherit no properties but 
  do inherit methods that can be overridden as needed.

  HGSETGET methods:
  - set      - Set MATLAB object property values.
  - get      - Get MATLAB object properties.
  
  This class is also equivalent to the ```matlab.mixin.SetGet class```.

  See also handle, dynamicprops
  
Usage
=====
The class derives from ```handle```, so that defining your class as:
```matlab
classdef myClass < hgsetget
  properties
    field1
  end
  ...
end
```
also sets it as a 'handle', that is a reference (pointer) object, with the attached methods and properties.
See https://octave.org/doc/v4.2.2/Value-Classes-vs_002e-Handle-Classes.html#Value-Classes-vs_002e-Handle-Classes

Then use:
```matlab
obj = myClass;
set(obj,'field1', 42)
get(obj,'field1')

```

Example
=======
You may test the ```hgsetget`` class by running:
```matlab
addpath /path/to/octave-hgsetget
hgsetget_demo
```
which should return 'OK'. Look at its source to see how to use the class.

Credits
=======
(c) E. Farhi / Synchrotron Soleil (2019), GPL 2.
