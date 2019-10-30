# octave-hgsetget
An Octave superclass used to derive handle class with set and get methods

  ```classdef myclass < hgsetget``` makes ```myclass``` a subclass of
  ```hgsetget``` and provide set and get methods.

  Classes that are derived from ```hgsetget``` inherit from new methods:
  - set Set object property values.
  - get Get object properties.

See also handle, dynamicprops
  
Usage
=====
The class derives from ```handle```, so that defining your class as:
```octave
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
```octave
obj = myClass;
set(obj,'field1', 42)
get(obj,'field1')

```

Example
=======
You may test the ```hgsetget`` class by running:
```octave
addpath /path/to/octave-hgsetget
hgsetget_demo
```
which should return 'OK'. Look at its source to see how to use the class.

Credits
=======
(c) E. Farhi / Synchrotron Soleil (2019), GPL 2.
