## demo for hgsetget

## create object from a derived class
obj = hgsetget_class;

obj.field1= 42;
obj.field2= nan;

disp (get (obj,"field1"))
set (obj,"field1", -42);

disp (get (obj,"field1"))

if (obj.field1 == -42)
  disp ("Test: OK") 
else 
  disp ("Test: FAILED"); 
endif
