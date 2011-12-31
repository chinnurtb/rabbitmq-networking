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

-module(rabbit_types).

-include("rabbit.hrl").

-ifdef(use_specs).

-export_type([maybe/1, info/0, infos/0, info_key/0, info_keys/0,
              vhost/0, ctag/0, amqp_error/0, r/1, r2/2, r3/3, listener/0,
              amqqueue/0, 
              connection/0, protocol/0, user/0, internal_user/0,
              username/0, password/0, password_hash/0, ok/1, error/1,
              ok_or_error/1, ok_or_error2/2, ok_pid_or_error/0, channel_exit/0,
              connection_exit/0]).

-type(channel_exit() :: no_return()).
-type(connection_exit() :: no_return()).

-type(maybe(T) :: T | 'none').
-type(vhost() :: binary()).
-type(ctag() :: binary()).

%% TODO: make this more precise by tying specific class_ids to
%% specific properties
-type(info_key() :: atom()).
-type(info_keys() :: [info_key()]).

-type(info() :: {info_key(), any()}).
-type(infos() :: [info()]).

-type(amqp_error() ::
        #amqp_error{name        :: rabbit_framing:amqp_exception(),
                    explanation :: string(),
                    method      :: rabbit_framing:amqp_method_name()}).

-type(r(Kind) ::
        r2(vhost(), Kind)).
-type(r2(VirtualHost, Kind) ::
        r3(VirtualHost, Kind, rabbit_misc:resource_name())).
-type(r3(VirtualHost, Kind, Name) ::
        #resource{virtual_host :: VirtualHost,
                  kind         :: Kind,
                  name         :: Name}).

-type(listener() ::
        #listener{node     :: node(),
                  protocol :: atom(),
                  host     :: rabbit_networking:hostname(),
                  port     :: rabbit_networking:ip_port()}).

-type(amqqueue() ::
        #amqqueue{name            :: rabbit_amqqueue:name(),
                  durable         :: boolean(),
                  auto_delete     :: boolean(),
                  exclusive_owner :: rabbit_types:maybe(pid()),
                  arguments       :: rabbit_framing:amqp_table(),
                  pid             :: rabbit_types:maybe(pid()),
                  slave_pids      :: [pid()],
                  mirror_nodes    :: [node()] | 'undefined' | 'all'}).


-type(connection() :: pid()).

-type(protocol() :: rabbit_framing:protocol()).

-type(user() ::
        #user{username     :: username(),
              tags         :: [atom()],
              auth_backend :: atom(),
              impl         :: any()}).

-type(internal_user() ::
        #internal_user{username      :: username(),
                       password_hash :: password_hash(),
                       tags          :: [atom()]}).

-type(username() :: binary()).
-type(password() :: binary()).
-type(password_hash() :: binary()).

-type(ok(A) :: {'ok', A}).
-type(error(A) :: {'error', A}).
-type(ok_or_error(A) :: 'ok' | error(A)).
-type(ok_or_error2(A, B) :: ok(A) | error(B)).
-type(ok_pid_or_error() :: ok_or_error2(pid(), any())).

-endif. % use_specs
