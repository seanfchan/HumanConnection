class ConnectionController < ApplicationController
  before_filter :login_required

  # GET /connections
  # GET /connections.xml
  def index
    @connections = current_user.connections

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @connections }
    end
  end

  # GET /connections/new
  # GET /connections/new.xml
  def new
    @connection = current_user.connections.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @connection }
    end
  end

  # POST /connections
  # POST /connections.xml
  def create
    @connection = current_user.connections.new(params[:connection])
    @connection.type = params[:type]

    respond_to do |format|
      if @connection.save
        format.html { redirect_to(@connection, :notice => 'Account was successfully created.') }
        format.xml  { render :xml => @connection, :status => :created, :location => @connection }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /connections/1
  # PUT /connections/1.xml
  def update
    @connection = current_user.connections.find(params[:id])

    respond_to do |format|
      if @connection.update_attributes(params[:connection])
        format.html { redirect_to(@connection, :notice => 'Account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /connections/1
  # DELETE /connections/1.xml
  def destroy
    @connection = current_user.connections.find(params[:id])
    @connection.destroy

    respond_to do |format|
      format.html { redirect_to(connections_url) }
      format.xml  { head :ok }
    end
  end
end
