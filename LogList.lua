-------------------------------------------------
-- Console - a debug log
-- 
-- @classmod LogList
-- @author Pawkette ( pawkette.heals@gmail.com )
--[[
The MIT License (MIT)

Copyright (c) 2014 Pawkette

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]
-------------------------------------------------

LogList = 
{
    first = 1,
    last = 0, 
    data = {}
}

function LogList:New( ... )
    local self = {}
    setmetatable( self, { __index = LogList } )

    self:Initialize()
    return self
end

function LogList:Initialize()

end

function LogList:Push( value )
    self.last = self.last + 1
    self.data[ self.last ] = value
end

function LogList:Pop()
    if ( self.first > self.last ) then 
        return nil
    end

    local value = self.data[ self.first ]
    self.data[ self.first ] = nil

    self.first = self.first + 1
end

function LogList:Size()
    return self.last - self.first
end

function LogList:First()
    return self.first 
end

function LogList:Last()
    return self.last
end

function LogList:Clear()
    self.data = {}
    self.first = 1
    self.last = 0 
end

function LogList:At( index )
    return self.data[ index ]
end