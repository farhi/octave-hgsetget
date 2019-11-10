## Copyright (C) 2019 Emmanuel Farhi
##
## This file is part of Octave.
##
## Octave is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or (at
## your option) any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn  {Function File} hgsetget
## A superclass to add set and get methods such as those used for Handle Graphics.
##
## This superclass should be used to derive an other class from it, e.g.
##
## @code{classdef} @var{myClass} < @code{hgsetget}
##   @code{properties}
##     @code{field1}
##   @code{end}
## @code{end}
## 
## then use the @code{set} and @code{get} methods, e.g.
##
## @var{obj} = myClass;
## @code{set} (@var{obj}, "field1", 42)
## @code{get} (@var{obj},"field")
##
## @multitable @columnfractions 0.15 0.8
## @headitem Method @tab Description
## @item set @tab Set named property values for the object
## @item get @tab Get named property values for the object
## @end multitable
## @seealso{handle,dynamicprops}
## @end deftypefn

## Author: Farhi

classdef (Abstract) hgsetget < handle
  
  ## methods --------------------------------------------------------------------
  methods
    function s = set (s, varargin)
    ## -*- texinfo -*-
    ## @deftypefn  {Function File} @var{VAL} = get (@var{H}, @var{P})
    ##  Return the value of the named property @var{P} from the object @var{H}.
    ##
    ##  If @var{P} is omitted, return the complete property list for @var{H}.
    ##
    ##  If @var{H} is a vector, return a cell array including the property values
    ##  or lists respectively.
    ##
    ## @seealso{get}
    ## @end deftypefn

      field="";
      value=[];
      if (nargin >=2),  field = varargin{1}; endif
      if (nargin >=3),  value = varargin{2}; endif
      if (isempty(field)), s = fieldnames (s); return; endif
      
      ## handle array of objects
      if (numel(s) > 1)
        for index=1:numel(s)
          s (index) = set (s (index), field, value);
        endfor
        return
      endif
      
      if (ischar (field) && size (field, 1) > 1)
        field = cellstr (field);
      endif
      
      ## handle array/cell of fields
      if (iscellstr (field))
        for index=1:numel(field)
          s (index) = set (s, field {index}, value);
        endfor
        return
      endif
      
      if (~ischar(field))
        error ([ mfilename ": SET: field to set in object, must be a char or cellstr, not " class (field) ]);
      endif
      
      ## cut the field into pieces with '.' as separator
      [tok, rem] = strtok (field, ".");
      
      if (~isfield (s, tok))
        s.(tok) = [];
      endif
      
      ## when rem is empty, we are were to set the value
      if (isempty (rem))
        s = setfield (s, tok, value);
        return
      endif
      
      ## else get the sub-struct
      s2 = getfield (s, tok);
      
      ## access deeper content recursively
      if (~isstruct(s2))
        s2 = []; # overwrite existing value
      endif
      s2 = set (s2, rem (2:end), value);
      
      s = setfield (s, tok, s2); # update in parent struct/object

    endfunction # set
    
    function v = get(s, varargin)
    ## -*- texinfo -*-
    ## @deftypefn  {Function File} set (@var{H}, @var{PROPERTY}, @var{VALUE}, ...)
    ## Set named property values for the object @var{H}.
    ##
    ## Each @var{PROPERTY} is a string containing the property name.
    ## Each @var{VALUE} is a value of the appropriate type for the property.
    ##
    ## @seealso{get}
    ## @end deftypefn

      if (nargin == 1), field=""; else field = varargin{1}; endif
      if (isempty(field)), v = fieldnames(s); return; endif
      v = [];
      
      ## handle array of objects
      if (numel(s) > 1)
        sout = {};
        for index=1:numel(s)
          sout{end+1} = get (s (index), field);
        endfor
        sout = reshape (sout, size (s));
        v = sout; 
        return
      endif
      
      if (ischar (field) && size (field, 1) > 1)
        field = cellstr (field);
      endif
      
      ## handle array/cell of fields
      if (iscellstr (field))
        sout = {};
        for index=1:numel(field)
          sout {end+1} = get (s, field {index});
        endfor
        sout = reshape (sout, size (field));
        v = sout; 
        return
      endif
      
      if (~ischar (field))
        error ([ mfilename ": GET: field to search in object must be a char or cellstr, not " class (field) ]);
      endif
      
      ## cut the field into pieces with '.' as separator
      [tok, rem] = strtok (field, ".");
      
      ## get the highest level
      v = getfield (s, tok);
      if (~isempty (rem) && isstruct (v))
        ## and access deeper content recursively
        v = get (v, rem (2:end));
      endif
  
    endfunction # get
    
  endmethods # methods
    
endclassdef # classdef

## Tests for hgsetget
%!  classdef hgsetget_class < hgsetget
%!    properties
%!      field1
%!    endproperties
%!  endclassdef

%!test
%!  obj = hgsetget_class;
%!  obj.field1= 42;
%!  assert (obj.field1, 42)
%!  set (obj,"field1", -42);
%!  assert (get (obj, "field1"), -42)

