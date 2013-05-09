# == Schema Information
#
# Table name: OPRMOV1_BASE
#
# PF IEMP					:smallint (T_IEMP)				not null
# PF INUMOPER 				:integer (T_INUMOPER)			not null
# BCOMANDOSIMPRESION		:char(1) (T_BOOLEAN )			DEFAULT 'F'


# -*- encoding : utf-8 -*-
class Oprmov1Base < ActiveRecord::Base
	establish_connection :firebird
	attr_accessible :iemp, :inumoper, :bcomandosimpresion

	set_table_name "OPRMOV1_BASE"

end