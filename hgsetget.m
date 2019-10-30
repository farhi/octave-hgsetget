classdef hgsetget < handle
% HGSETGET   HG-style set and get for MATLAB objects.
%   The HGSETGET class is an abstract class that provides an HG-style
%   property set and get interface.  HGSETGET is a subclass of HANDLE, so 
%   any classes derived from HGSETGET are handle classes.  
% 
%   classdef myclass < hgsetget makes 'myclass' a subclass of
%   HGSETGET.
% 
%   Classes that are derived from HGSETGET inherit no properties but 
%   do inherit methods that can be overridden as needed.
% 
%   HGSETGET methods:
%       set      - Set MATLAB object property values.
%       get      - Get MATLAB object properties.
%
%   This class is also equivalent to the matlab.mixin.SetGet class
% 
%   See also handle, dynamicprops
  
  % no properties
  
  % methods --------------------------------------------------------------------
  methods
    function s = set(s, varargin)
    % SET    Set object properties.
    %    V = SET(S,'PropertyName','Value') set the value of the specified
    %    property/field in the object.  
    %    The 'PropertyName' can be a full path in object, such as 'field1.field2' in
    %    in which case the value assigment is made recursive.
    % 
    %    SET(S) displays all object field names.

      field='';
      value=[];
      if nargin >=2,  field=varargin{1}; end
      if nargin >=3,  value=varargin{2}; end
      if isempty(field), s = fieldnames(s); return; end
      
      % handle array of objects
      if numel(s) > 1
        for index=1:numel(s)
          s(index) = set(s(index), field, value);
        end
        return
      end
      
      if ischar(field) && size(field, 1) > 1
        field = cellstr(field);
      end
      
      % handle array/cell of fields
      if iscellstr(field)
        for index=1:numel(field)
          s(index) = set(s, field{index}, value);
        end
        return
      end
      
      if ~ischar(field)
        error([ mfilename ': SET: field to set in object, must be a char or cellstr, not ' class(field) ]);
      end
      
      % cut the field into pieces with '.' as separator
      [tok, rem] = strtok(field, '.');
      
      if ~isfield(s, tok)
        s.(tok) = [];
      end
      
      % when rem is empty, we are were to set the value
      if isempty(rem)
        s = setfield(s, tok, value);
        return
      end
      
      % else get the sub-struct
      s2 = getfield(s, tok);
      
      % access deeper content recursively
      if ~isstruct(s2)
        s2 = []; % overwrite existing value
      end
      s2 = set(s2, rem(2:end), value);
      
      s = setfield(s, tok, s2); % update in parent struct/object

    end % set
    
    function v = get(s, varargin)
    % GET    Get object properties.
    %    V = GET(S,'PropertyName') returns the value of the specified
    %    property/field in the object.  If S is an array, then get will 
    %    return a cell array of values.  
    %    If 'PropertyName' is replaced by a 1-by-N or N-by-1 cell array of strings 
    %    containing property names, then GET will return an M-by-N cell array of
    %    values.
    %    The 'PropertyName' can be a full path in object, such as 'field1.field2' in
    %    in which case the value retrieval is made recursive.
    % 
    %    GET(S) displays all object field names.

      if nargin == 1, field=''; else field = varargin{1}; end
      if isempty(field), v = fieldnames(s); return; end
      v = [];
      
      % handle array of objects
      if numel(s) > 1
        sout = {};
        for index=1:numel(s)
          sout{end+1} = get(s(index), field);
        end
        sout = reshape(sout, size(s));
        v = sout; 
        return
      end
      
      if ischar(field) && size(field, 1) > 1
        field = cellstr(field);
      end
      
      % handle array/cell of fields
      if iscellstr(field)
        sout = {};
        for index=1:numel(field)
          sout{end+1} = get(s, field{index});
        end
        sout = reshape(sout, size(field));
        v = sout; 
        return
      end
      
      if ~ischar(field)
        error([ mfilename ': GET: field to search in object must be a char or cellstr, not ' class(field) ]);
      end
      
      % cut the field into pieces with '.' as separator
      [tok, rem] = strtok(field, '.');
      
      % get the highest level
      v = getfield(s, tok);
      if ~isempty(rem) && isstruct(v)
        % an access deeper content recursively
        v = get(v, rem(2:end));
      end
  
    end % get
    
  end % methods
    
end
