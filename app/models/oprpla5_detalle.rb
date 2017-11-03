# == Schema Information
#
# Table name: OPRPLA5_DETALLE
#
# IEMP 						:smallint (T_IEMP)				not null
# INUMOPER 					:integer (T_INUMOPER)			not null
# ILINEA 					:integer (T_ILINEA) 			not null
# ITDCONTRATO 				:smallint (T_ITDCONTRATO)
# ICONTRATO 				:varchar(20) (T_NUMSOP)
# ICEDULA 					:varchar(20) (T_INIT)
# NTRABAJADOR				:varchar(40)
# ICCLUNES 					:varchar(20) (T_ICC)
# IACTIVIDADLUNES			:varchar(6) (T_IACTIVIDAD)
# ILABORLUNES				:varchar(6) (T_ILABOR)
# QJORSLUNES				:numeric(12,8) (T_CANT_FLOTANTES)
# QCANTLUNES				:numeric(12,8) (T_CANT_FLOTANTES)
# BCANTDESCLUNES			:char(1) (T_BOOLEAN)
# ICCMARTES					:varchar(20) (T_ICC)
# IACTIVIDADMARTES			:varchar(6) (T_IACTIVIDAD)
# ILABORMARTES				:varchar(6) (T_ILABOR)
# QJORSMARTES				:numeric(12,8) (T_CANT_FLOTANTES)
# QCANTMARTES				:numeric(12,8) (T_CANT_FLOTANTES)
# BCANTDESCMARTES			:char(1) (T_BOOLEAN)
# ICCMIERCOLES				:varchar(20) (T_ICC)
# IACTIVIDADMIERCOLES		:varchar(6) (T_IACTIVIDAD)
# ILABORMIERCOLES			:varchar(6) (T_ILABOR)
# QJORSMIERCOLES			:numeric(12,8) (T_CANT_FLOTANTES)
# QCANTMIERCOLES			:numeric(12,8) (T_CANT_FLOTANTES)
# BCANTDESCMIERCOLES		:char(1) (T_BOOLEAN)
# ICCJUEVES					:varchar(20) (T_ICC)
# IACTIVIDADJUEVES			:varchar(6) (T_IACTIVIDAD)
# ILABORJUEVES				:varchar(6) (T_ILABOR)
# QJORSJUEVES				:numeric(12,8) (T_CANT_FLOTANTES)
# QCANTJUEVES				:numeric(12,8) (T_CANT_FLOTANTES)
# BCANTDESCJUEVES			:char(1) (T_BOOLEAN)
# ICCVIERNES				:varchar(20) (T_ICC)
# IACTIVIDADVIERNES			:varchar(6) (T_IACTIVIDAD)
# ILABORVIERNES				:varchar(6) (T_ILABOR)
# QJORSVIERNES				:numeric(12,8) (T_CANT_FLOTANTES)
# QCANTVIERNES				:numeric(12,8) (T_CANT_FLOTANTES)
# BCANTDESCVIERNES			:char(1) (T_BOOLEAN)
# ICCSABADO					:varchar(20) (T_ICC)
# IACTIVIDADSABADO			:varchar(6) (T_IACTIVIDAD)
# ILABORSABADO				:varchar(6) (T_ILABOR)
# QJORSSABADO				:numeric(12,8) (T_CANT_FLOTANTES)
# QCANTSABADO				:numeric(12,8) (T_CANT_FLOTANTES)
# BCANTDESCSABADO			:char(1) (T_BOOLEAN)
# ICCDOMINGO				:varchar(20) (T_ICC)
# IACTIVIDADDOMINGO			:varchar(6) (T_IACTIVIDAD)
# ILABORDOMINGO				:varchar(6) (T_ILABOR)
# QJORSDOMINGO				:numeric(12,8) (T_CANT_FLOTANTES)
# QCANTDOMINGO				:numeric(12,8) (T_CANT_FLOTANTES)
# BCANTDESCDOMINGO			:char(1) (T_BOOLEAN)
# QTOTALJORS				:numeric(12,8) (T_CANT_FLOTANTES)
# QTOTALCANT				:numeric(12,8) (T_CANT_FLOTANTES)
# MVRTOTAL					:numeric(18,4) (T_MONETARIO)
# MVRDCTO1					:numeric(18,4) (T_MONETARIO)
# MVRDCTO2					:numeric(18,4) (T_MONETARIO)
# MVRDCTO3					:numeric(18,4) (T_MONETARIO)
# MVRDCTO4					:numeric(18,4) (T_MONETARIO)
# MTOTALAPAGAR				:numeric(18,4) (T_MONETARIO)
# ICHEQUE					:varchar(10) (T_ITRANSACCIONBANCARIA)
# SOBSERV 					:varchar(200) (T_SOBSERVOPRS)
# QFACTOR					:numeric(12,8) (T_CANT_FLOTANTES)
# ILINEAMOV					:integer (T_ILINEA)

# -*- encoding : utf-8 -*-
class Oprpla5Detalle < ActiveRecord::Base
	establish_connection :firebird
	attr_accessible :iemp, :inumoper, :ilinea, :itdcontrato, :icontrato, :icedula, 
	:ntrabajador, :icclunes, :iactividadlunes, :ilaborlunes, :qjorslunes, :qcantlunes, 
	:bcantdesclunes, :iccmartes, :iactividadmartes, :ilabormartes, :qjorsmartes, 
	:qcantmartes, :bcantdescmartes, :iccmiercoles, :iactividadmiercoles, :ilabormiercoles, 
	:qjorsmiercoles, :qcantmiercoles, :bcantdescmiercoles, :iccjueves, :iactividadjueves, 
	:ilaborjueves, :qjorsjueves, :qcantjueves, :bcantdescjueves, :iccviernes, 
	:iactividadviernes, :ilaborviernes, :qjorsviernes, :qcantviernes, :bcantdescviernes, 
	:iccsabado, :iactividadsabado, :ilaborsabado, :qjorssabado, :qcantsabado, 
	:bcantdescsabado, :iccdomingo, :iactividaddomingo, :ilabordomingo, :qjorsdomingo, 
	:qcantdomingo, :bcantdescdomingo, :qtotaljors, :qtotalcant, :mvrtotal, :mvrdcto1, 
	:mvrdcto2, :mvrdcto3, :mvrdcto4, :mtotalapagar, :icheque, :sobserv, :qfactor, 
	:ilineamov

	self.set_table_name "OPRPLA5_DETALLE"
	# set_table_name "OPRPLA5_DETALLE"

	# Constants
	IACTIVIDADLUNES = 1.freeze
	QCANTLUNES = 0.freeze
	BCANTDESCLUNES = 'T'.freeze
	QFACTOR = 1.freeze
	ILINEAMOV = 0.freeze

end