-module(iamrolerl).
-behaviour(gen_server).

%% API.
-export([start_link/0]).

%% gen_server.
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
				 terminate/2, code_change/3]).

-record(state, {}).

-define(METADATA_HOST, "169.254.169.254").

%% API.

-spec start_link() -> {ok, pid()}.
start_link() ->
	gen_server:start_link(?MODULE, [], []).

%% gen_server.

init([]) ->
	State = #state{},
	{ok, load_metadata(State)}

handle_call(_Request, _From, State) ->
	{reply, ignored, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

load_metadata(State) ->
	SocketOpts = [{packet, http_bin}],
	case gen_tcp:connect(?METADATA_HOST, 80, SocketOpts) of
		{ok, Socket} ->
			Req = {http_request, 'GET', "/", {1, 1}},
			ok = gen_tcp:send(Req)
