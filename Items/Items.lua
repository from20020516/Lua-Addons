--[[
Copyright © 2018, from20020516
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
        notice, this list of conditions and the following disclaimer in the
        documentation and/or other materials provided with the distribution.
    * Neither the name of Items nor the
        names of its contributors may be used to endorse or promote products
        derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL from20020516 BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.]]
_addon.name = 'items'
_addon.author = 'from20020516'
_addon.version = '1.0'
_addon.command = 'items'

res = require('resources')
packets = require('packets')
config = require('config')

defaults = {case = '聖水|薬$',locker = '',safe = '',safe2 = '',sack = '',satchel = '',storage = '',
    wardrobe = '',wardrobe2 = '',wardrobe3 = '',wardrobe4 = '',}
settings = config.load(defaults)
language = {English='english',Japanese='ja'}[windower.ffxi.get_info().language]

windower.register_event('addon command',function(command,name,counts)
    local counts = tonumber(counts)
    local get_bag_info = windower.ffxi.get_bag_info
    local settings = config.load()
    local name = name and {english=name,ja=windower.from_shift_jis(name)}[language]
    local nomad = check_nomad()
    local bag_index = {
        ['safe']=(get_bag_info(1).enabled or nomad) and 1 or nil,
        ['safe2']=(get_bag_info(9).enabled or nomad) and 9 or nil,
        ['storage']=get_bag_info(2).enabled and 2 or nil,
        ['locker']=(get_bag_info(4).enabled or nomad) and 4 or nil,
        ['satchel']=get_bag_info(5).enabled and 5 or nil,
        ['sack']=get_bag_info(6).enabled and 6 or nil,
        ['case']=7,
        ['wardrobe']=8,
        ['wardrobe2']=10,
        ['wardrobe3']=get_bag_info(11).enabled and 11 or nil,
        ['wardrobe4']=get_bag_info(12).enabled and 12 or nil}
    local get_items = windower.ffxi.get_items
    local get_item = windower.ffxi.get_item
    local put_item = windower.ffxi.put_item
    local drop_item = windower.ffxi.drop_item

    if command == 'get' then
        local bag_index = bag_index[name] and {[name]=bag_index[name]} or bag_index
        for bag_name,bag_id in pairs(bag_index) do
            for i,v in ipairs(get_items(bag_id)) do
                if v.id > 0 then
                    local item = res.items[v.id]
                    if windower.regex.match(item[language],name)
                    or bag_index[name] and not S{10,14}[item.type] then
                        get_item(bag_id,i,counts or v.count)
                        if counts then
                            break;
                        end
                    end
                end
            end
        end

    elseif S{'put','discardsall'}[command] then
        for i,v in ipairs(get_items(0)) do
            if v.id > 0 then
                local item = res.items[v.id]
                if command == 'put' then
                    if bag_index[name] then
                        put_item(bag_index[name],i,v.count)
                    elseif not name then
                        for bag_name,pattern in pairs(settings) do
                            if bag_index[bag_name] and type(pattern) == 'string' and pattern ~= ''
                            and windower.regex.match(item[language],pattern) then
                                put_item(bag_index[bag_name],i,v.count)
                            end
                        end
                    end
                elseif command == 'discardsall' and not S{4,5,6}[item.type] then
                    drop_item(i,v.count)
                end
            end
        end
        coroutine.schedule(sort_items,3)

    elseif command == 'use' and name then
        local item = res.items:with(language,name)
        if item.category == 'Usable' then
            for i=1,counts do
                windower.chat.input('/item '..windower.to_shift_jis(item[language])..' <me>')
                coroutine.sleep(math.max(item.cast_time*2,3))
            end
        end
    end
end)

function check_nomad()
    local forest = S{26,53,247,248,249,250,252}
    if forest[windower.ffxi.get_info().zone] then
        for i,v in pairs(windower.ffxi.get_mob_array()) do
            if v.name == 'Nomad Moogle' and math.sqrt(v.distance) < 6 then
                return true;
            end
        end
    end
end

function sort_items()
    for i=5,7 do
        local packet = packets.new('outgoing',0x03A)
        packet["Bag"] = i
        packets.inject(packet)
    end
end
