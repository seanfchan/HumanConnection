class ConnectionController < ApplicationController
  before_filter :login_required

  # GET /connections
  # GET /connections.json
  def index
    @connections = current_user.connections

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @connections }
    end
  end

  # GET /connections/new
  # GET /connections/new.json
  def new
    @connection = current_user.connections.new

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @connection }
    end
  end

  # POST /connections
  # POST /connections.json
  def create
    @connection = current_user.connections.new(params[:connection])
    @connection.type = params[:type]

    respond_to do |format|
      if @connection.save
        format.html { redirect_to(@connection, :notice => 'Account was successfully created.') }
        format.json  { render :json => @connection, :status => :created, :location => @connection }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /connections/1
  # PUT /connections/1.json
  def update
    @connection = current_user.connections.find(params[:id])

    respond_to do |format|
      if @connection.update_attributes(params[:connection])
        format.html { redirect_to(@connection, :notice => 'Account was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /connections/1
  # DELETE /connections/1.json
  def destroy
    @connection = current_user.connections.find(params[:id])
    @connection.destroy

    respond_to do |format|
      format.html { redirect_to(connections_url) }
      format.json  { head :ok }
    end
  end
end
