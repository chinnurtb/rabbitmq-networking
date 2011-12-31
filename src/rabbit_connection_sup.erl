%% The contents of this file are subject to the Mozilla Public License
%% Version 1.1 (the "License"); you may not use this file except in
%% compliance with the License. You may obtain a copy of the License
%% at http://www.mozilla.org/MPL/
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and
%% limitations under the License.
%%
%% The Original Code is RabbitMQ.
%%
%% The Initial Developer of the Original Code is VMware, Inc.
%% Copyright (c) 2007-2011 VMware, Inc.  All rights reserved.
%%

-module(rabbit_connection_sup).

-behaviour(supervisor2).

-export([start_link/0, reader/1]).

-export([init/1]).

-include("rabbit.hrl").

%%----------------------------------------------------------------------------

-ifdef(use_specs).

-spec(start_link/0 :: () -> {'ok', pid(), pid()}).
-spec(reader/1 :: (pid()) -> pid()).

-endif.

%%--------------------------------------------------------------------------

start_link() ->
    {ok, SupPid} = supervisor2:start_link(?MODULE, []),
    {ok, ClientPid} =
        supervisor2:start_child(
          SupPid,
          {client, {rabbit_client, start_link, []},
           intrinsic, ?MAX_WAIT, worker, [rabbit_client]}),
    {ok, ReaderPid} =
        supervisor2:start_child(
          SupPid,
          {reader, {rabbit_reader, start_link, [ClientPid]},
           intrinsic, ?MAX_WAIT, worker, [rabbit_reader]}),
    {ok, SupPid, ReaderPid}.

reader(Pid) ->
    hd(supervisor2:find_child(Pid, reader)).

%%--------------------------------------------------------------------------

init([]) ->
    {ok, {{one_for_all, 0, 1}, []}}.

