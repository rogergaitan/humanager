# == Schema Information
#
# Table name: OPRPLA5_BASE
#
# IEMP 						:smallint (T_IEMP)				not null
# INUMOPER 					:integer (T_INUMOPER)			not null
# ICUENTACAJA				:varchar(30) (T_ICUENTA)
# ICUENTABANCO				:varchar(30) (T_ICUENTA)
# IBANCO 					:varchar(4) (T_IBANCO)
# BPAGOCXP 					:char(1) (T_BOOLEAN)
# IFLUJOEFECCAJA 			:varchar(5) (T_IFLUJOEFEC)
# IFLUJOEFECBANCO 			:varchar(5) (T_IFLUJOEFEC)
# INITDCTO1 				:varchar(20) (T_INIT)
# INITDCTO2 				:varchar(20) (T_INIT)
# INITDCTO3 				:varchar(20) (T_INIT)
# INITDCTO4					:varchar(20) (T_INIT)
# ITIPOCOSTEO 				:smallint
# BPROCESOPORDIA 			:char(1) (T_BOOLEAN)
# BRENDIMCMP 				:char(1) (T_BOOLEAN)
# QREGCTOLABOR 				:smallint
# QREGCTOS 					:smallint
# QREGFPAGODCTO1 			:smallint
# QREGFPAGODCTO2 			:smallint
# QREGFPAGODCTO3 			:smallint
# QREGFPAGODCTO4 			:smallint
# QREGFPAGOPAGADOR 			:smallint

# -*- encoding : utf-8 -*-
class Oprpla5Base < ActiveRecord::Base
  establish_connection :firebird
  
	attr_accessible :iemp, :inumoper, :icuentacaja, :icuentabanco, :ibanco, :bpagocxp, 
                  :iflujoefeccaja, :iflujoefecbanco, :initdcto1, :initdcto2, :initdcto3,
                  :initdcto4, :itipocosteo, :bprocesopordia, :brendimcmp, :qregctolabor,
                  :qregctos, :qregfpagodcto1, :qregfpagodcto2, :qregfpagodcto3,
                  :qregfpagodcto4, :qregfpagopagador

	set_table_name "OPRPLA5_BASE"

	# Constants
	BPAGOCXP = 'T'.freeze
	ITIPOCOSTEO = 0.freeze
	BPROCESOPORDIA = 'F'.freeze
	BRENDIMCMP = 'F'.freeze
	QREGCTOLABOR = 0.freeze
	QREGCTOS = 0.freeze
	QREGFPAGODCTO1 = 0.freeze
	QREGFPAGODCTO2 = 0.freeze
	QREGFPAGODCTO3 = 0.freeze
	QREGFPAGODCTO4 = 0.freeze
	QREGFPAGOPAGADOR = 0.freeze

end