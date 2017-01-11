-module(glc_run).

-export([execute/2]).

-ifdef(NO_MONOTONIC_TIME).
-define(time_now(),         os:timestamp()).
-define(time_diff(T1, T2),  timer:now_diff(T2, T1)).
-else.
-define(time_now(),         erlang:monotonic_time()).
-define(time_diff(T1, T2),  erlang:convert_time_unit(T2 - T1, native, micro_seconds)).
-endif.

execute(Fun, [Event, Store]) ->
    T1 = ?time_now(),
    case (catch Fun(Event, Store)) of
        {'EXIT', {Reason, _ST}} ->
            T2 = ?time_now(),
            {?time_diff(T1, T2), {error, Reason}};
        {'EXIT', Reason} ->
            T2 = ?time_now(),
            {?time_diff(T1, T2), {error, Reason}};
        Else ->
            T2 = ?time_now(),
            {?time_diff(T1, T2), Else}
    end.


