-module(interface).
-export([new/0, add/4, remove/2, lookup/2, ref/2, name/2, list/1, broadcast/2]).

new()->
    [].

add(Name, Ref, Pid, Intf) ->
    lists:keystore(Name, 1, Intf, {Name, Ref, Pid}).

remove(Name, Intf) ->
    lists:keydelete(Name, 1, Intf).

lookup(Name, Intf) -> 
    case lists:keyfind(Name, 1, Intf) of
        {_,_,Pid} -> Pid;
        false -> notfound 
    end.

ref(Name, Intf) ->
    case lists:keyfind(Name, 1, Intf) of
        {_,Ref,_} -> Ref;
        false -> notfound 
    end.

name(Ref, Intf) ->
    case lists:keyfind(Ref, 2, Intf) of
        {Name,_,_} -> Name;
        false -> notfound 
    end.

list(Intf)->
    lists:map(fun({Name,_,_}) -> Name end, Intf).
    %lists:foldl(fun({Name,_,_}, Acc) -> [Name|Acc] end, [], Intf).

broadcast(Message, Intf) ->
    lists:foreach(fun({_, _, Pid}) ->
		Pid ! Message end, Intf).