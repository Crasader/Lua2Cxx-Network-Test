--[[
   Author: Julio Manuel Fernandez-Diaz
   Date:   January 12, 2007
   (For Lua 5.1)
   
   Modified slightly by RiciLake to avoid the unnecessary table traversal in tablecount()

   Formats tables with cycles recursively to any depth.
   The output is returned as a string.
   References to other tables are shown as values.
   Self references are indicated.

   The string returned is "Lua code", which can be procesed
   (in the case in which indent is composed by spaces or "--").
   Userdata and function keys and values are shown as strings,
   which logically are exactly not equivalent to the original code.

   This routine can serve for pretty formating tables with
   proper indentations, apart from printing them:

      print(table.show(t, "t"))   -- a typical use
   
   Heavily based on "Saving tables with cycles", PIL2, p. 113.

   Arguments:
      t is the table.
      name is the name of the table (optional)
      indent is a first indentation (optional).
--]]
function table.show(t, name, indent)
   local cart     -- a container
   local autoref  -- for self references

   --[[ counts the number of elements in a table
   local function tablecount(t)
      local n = 0
      for _, _ in pairs(t) do n = n+1 end
      return n
   end
   ]]
   -- (RiciLake) returns true if the table is empty
   local function isemptytable(t) return next(t) == nil end

   local function basicSerialize (o)
      local so = tostring(o)
      if type(o) == "function" then
         local info = debug.getinfo(o, "S")
         -- info.name is nil because o is not a calling level
         if info.what == "C" then
            return string.format("%q", so .. ", C function")
         else 
            -- the information is defined through lines
            return string.format("%q", so .. ", defined in (" ..
                info.linedefined .. "-" .. info.lastlinedefined ..
                ")" .. info.source)
         end
      elseif type(o) == "number" or type(o) == "boolean" then
         return so
      else
         return string.format("%q", so)
      end
   end

   local function addtocart (value, name, indent, saved, field)
      indent = indent or ""
      saved = saved or {}
      field = field or name

      cart = cart .. indent .. field

      if type(value) ~= "table" then
         cart = cart .. " = " .. basicSerialize(value) .. ";\n"
      else
         if saved[value] then
            cart = cart .. " = {}; -- " .. saved[value] 
                        .. " (self reference)\n"
            autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
         else
            saved[value] = name
            --if tablecount(value) == 0 then
            if isemptytable(value) then
               cart = cart .. " = {};\n"
            else
               cart = cart .. " = {\n"
               for k, v in pairs(value) do
                  k = basicSerialize(k)
                  local fname = string.format("%s[%s]", name, k)
                  field = string.format("[%s]", k)
                  -- three spaces between levels
                  addtocart(v, fname, indent .. "   ", saved, field)
               end
               cart = cart .. indent .. "};\n"
            end
         end
      end
   end

   name = name or "__unnamed__"
   if type(t) ~= "table" then
      return name .. " = " .. basicSerialize(t)
   end
   cart, autoref = "", ""
   addtocart(t, name, indent)
   return cart .. autoref
end




--------------------------------------------------------------------------------------------------------------------------------
g = {}
g["MESSAGE_TYPE"] = {}
g["MESSAGE_TYPE"]["TC_0"] = 0
g["MESSAGE_TYPE"]["TC_1"] = 1
g["MESSAGE_TYPE"]["TC_2"] = 2
g["MESSAGE_TYPE"]["TC_3"] = 3
g["MESSAGE_TYPE"]["TC_4"] = 4
g["MESSAGE_TYPE"]["TC_5"] = 5
g["MESSAGE_TYPE"]["TC_6"] = 6
g["MESSAGE_TYPE"]["TC_7"] = 7
g["MESSAGE_TYPE"]["TC_8"] = 8
g["MESSAGE_TYPE"]["TC_9"] = 9
g["MESSAGE_TYPE"]["TC_10"] = 10
g["MESSAGE_TYPE"]["TC_11"] = 11
g["MESSAGE_TYPE"][0] = "TC_0"
g["MESSAGE_TYPE"][1] = "TC_1"
g["MESSAGE_TYPE"][2] = "TC_2"
g["MESSAGE_TYPE"][3] = "TC_3"
g["MESSAGE_TYPE"][4] = "TC_4"
g["MESSAGE_TYPE"][5] = "TC_5"
g["MESSAGE_TYPE"][6] = "TC_6"
g["MESSAGE_TYPE"][7] = "TC_7"
g["MESSAGE_TYPE"][8] = "TC_8"
g["MESSAGE_TYPE"][9] = "TC_9"
g["MESSAGE_TYPE"][10] = "TC_10"
g["MESSAGE_TYPE"][11] = "TC_11"

--tc_0
local data0 = {["messageType"] = g["MESSAGE_TYPE"]["TC_0"]}

--tc_1
local data1 = {["messageType"] = g["MESSAGE_TYPE"]["TC_1"],["name"] = "F"}

--tc_2
local data2 = {
  ["messageType"] = g["MESSAGE_TYPE"]["TC_2"],
  ["o"] = {["name"] = nil}
}

--tc_3
local data3 = {
  ["messageType"] = g["MESSAGE_TYPE"]["TC_3"],
  ["mylist"] = {
    {["name"] = "D"}
  }
}

--tc_4
local data4 = {
  ["messageType"] = g["MESSAGE_TYPE"]["TC_4"],
  ["A"] = {
    ["B"] = {
      ["C"] = {
        ["D"] = {
        }
      }
    }
  },
  ["E"] = {}
}

--tc_5
local data5 = {
  ["messageType"] = g["MESSAGE_TYPE"]["TC_5"],
  ["A"] = {
    ["name"] = "A",
    ["B"] = {
      ["C"] = {
        ["D"] = {
        }
      }
    }
  },
  ["E"] = {}
}

--tc_6
local data6 = {
  ["messageType"] = g["MESSAGE_TYPE"]["TC_6"],
  ["name"] = "data",
  ["A"] = {},
  ["B"] = {},
  ["C"] = {},
  ["D"] = {
    ["E"] = {
      ["F"] = {}
    }
  }
}

--tc_7
local data7 = {
  ["messageType"] = g["MESSAGE_TYPE"]["TC_7"],
  ["string_field"] = "wh",
  ["boolean_field"] = true,
  ["char_field"] = 27,
  ["short_field"] = 32767,
  ["int_field"] = 2147483647,
  ["long_field"] = 99999999999999,
  ["double_field"] = 123456789.123456
}

-- tc_8
local data8 = {
  ["messageType"] = g["MESSAGE_TYPE"]["TC_8"],
  ["name"] = "wh",
  ["wife"] = {["name"] = "yj",["age"] = 27},
  ["kids"] = {
    {["name"] = "k1",["age"] = 1},
    {["name"] = "k2",["age"] = 2},
    {["name"] = "k3",["age"] = 3}
  }
}

--tc_9
local data9 = {
  ["messageType"] = g["MESSAGE_TYPE"]["TC_9"],
  ["wife"] = {
    ["father"] = {
      ["dogs"] = {
        {
          ["owners"] = {
            {
              ["name"] = "dog1_owner1",
              ["farms"] = {
                {["name"] = "farm1"},
                {["name"] = "farm2"},
                {["name"] = "farm3"}
              }
            },
            {
              ["name"] = "dog1_owner2",
              ["farms"] = {
                {["name"] = "farm1"},
                {["name"] = "farm2"},
                {["name"] = "farm3"}
              }
            }
          }
        }
      }
    }
  }
}

--tc_10
local data10 = {
  ["messageType"] = g["MESSAGE_TYPE"]["TC_10"],
  ["name"] = "wh",
  ["wife"] = {
    ["wife_name"] = {
      ["big_name"] = "yj",
      ["small_name"] = "jj"
    },
    ["age"] = 27,
    ["father"] = {
      ["name"] = "father Y",
      ["age"] = 58,
      ["dogs"] = {
        {
          ["name"] = "dog1",
          ["age"] = 1,
          ["owners"] = {
            {
              ["name"] = "dog1_owner1",
              ["age"] = 1,
              ["farms"] = {
                {["name"] = "farm1"},
                {["name"] = "farm2"},
                {["name"] = "farm3"}
              }
            },
            {
              ["name"] = "dog1_owner2",
              ["age"] = 2,
              ["farms"] = {
                {["name"] = "farm1"},
                {["name"] = "farm2"},
                {["name"] = "farm3"}
              }
            },
            {
              ["name"] = "dog1_owner3",
              ["age"] = 3,
              ["farms"] = {
                {["name"] = "farm1"},
                {["name"] = "farm2"},
                {["name"] = "farm3"}
              }
            }
          }
        },
        {
          ["name"] = "dog2",
          ["age"] = 2,
          ["owners"] = {
            {
              ["name"] = "dog2_owner1",
              ["age"] = 1,
              ["farms"] = {
                {["name"] = "farm1"},
                {["name"] = "farm2"},
                {["name"] = "farm3"}
              }
            },
            {
              ["name"] = "dog2_owner2",
              ["age"] = 2,
              ["farms"] = {
                {["name"] = "farm1"},
                {["name"] = "farm2"},
                {["name"] = "farm3"}
              }
            },
            {
              ["name"] = "dog2_owner3",
              ["age"] = 3,
              ["farms"] = {
                {["name"] = "farm1"},
                {["name"] = "farm2"},
                {["name"] = "farm3"}
              }
            }
          }
        },
        {
          ["name"] = "dog3",
          ["age"] = 3,
          ["owners"] = {
            {
              ["name"] = "dog3_owner1",
              ["age"] = 1,
              ["farms"] = {
                {["name"] = "farm1"},
                {["name"] = "farm2"},
                {["name"] = "farm3"}
              }
            },
            {
              ["name"] = "dog3_owner2",
              ["age"] = 2,
              ["farms"] = {
                {["name"] = "farm1"},
                {["name"] = "farm2"},
                {["name"] = "farm3"}
              }
            },
            {
              ["name"] = "dog3_owner3",
              ["age"] = 3,
              ["farms"] = {
                {["name"] = "farm1"},
                {["name"] = "farm2"},
                {["name"] = "farm3"}
              }
            }
          }
        }
      }
    }
  },
  ["kids"] = {
    {["name"] = "kid1",["age"] = 1},
    {["name"] = "kid2",["age"] = 2},
    {["name"] = "kid3",["age"] = 3}
  }
}

local data11 = {
  ["messageType"] = g["MESSAGE_TYPE"]["TC_11"],
  ["myInfo"] = {
    ["kids"] = {
      {["name"] = "kid1",["age"] = 1},
      {["name"] = "kid2",["age"] = 2},
      {["name"] = "kid3",["age"] = 3}
    }
  },
  ["wifes"] = {
    {["name"] = "w1"},
    {["name"] = "w2"},
    {["name"] = "w3"}
  }
}

local tcDataTable = {
  ["TC0"] = data0,
  ["TC1"] = data1,
  ["TC2"] = data2,
  ["TC3"] = data3,
  ["TC4"] = data4,
  ["TC5"] = data5,
  ["TC6"] = data6,
  ["TC7"] = data7,
  ["TC8"] = data8,
  ["TC9"] = data9,
  ["TC10"] = data10,
  ["TC11"] = data11
}

return tcDataTable