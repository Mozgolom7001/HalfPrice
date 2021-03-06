﻿
&НаКлиенте
Процедура АдресХраненияФайловПрайсовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = НСтр("ru = 'Выбор файла прайса'");
	Диалог.МножественныйВыбор = Ложь;
	Фильтр = НСтр("ru = 'ПрайсЛист'; en = 'Price'") + "(*.xls)|*.xls";
	Диалог.Фильтр = Фильтр;
	
	
	Если Диалог.Выбрать() Тогда
	
		Объект.ФайлПрайс = Диалог.ПолноеИмяФайла;
	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПрайс(Команда)
	
	Если Объект.ФайлПрайс = "" Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Выберите файл",, "Объект.ФайлПрайс");
		Возврат;
	
	КонецЕсли; 
	
	ЗагрузитьПрайсНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПрайсНаСервере()
	
	ТаблицаИзФайла = Новый ТабличныйДокумент;
	ТаблицаИзФайла.Прочитать(Объект.ФайлПрайс, СпособЧтенияЗначенийТабличногоДокумента.Текст);
	
	НомерПервойСтроки = 13;
	КоличествоСтрок = ТаблицаИзФайла.ВысотаТаблицы;
	
	Объект.АртикулыСЦенами.Очистить();
	
	Пока НомерПервойСтроки < КоличествоСтрок Цикл
		
		КодНоменклатуры = ТаблицаИзФайла.ПолучитьОбласть(НомерПервойСтроки, 3).ТекущаяОбласть.Текст;
		Если КодНоменклатуры = "" Тогда
		     НомерПервойСтроки = НомерПервойСтроки + 1;
			Продолжить;
		   
		КонецЕсли; 
		
		СтрокаТоваров = Объект.АртикулыСЦенами.Добавить();
		
		СтрокаТоваров.Наименование = ТаблицаИзФайла.ПолучитьОбласть(НомерПервойСтроки, 2).ТекущаяОбласть.Текст;
		СтрокаТоваров.КодНоменклатуры = КодНоменклатуры;
		СтрокаТоваров.Вес = ТаблицаИзФайла.ПолучитьОбласть(НомерПервойСтроки, 4).ТекущаяОбласть.Текст;
	    СтрокаТоваров.Объем = ТаблицаИзФайла.ПолучитьОбласть(НомерПервойСтроки, 5).ТекущаяОбласть.Текст;
		СтрокаТоваров.ГруппаНоменклатуры = ТаблицаИзФайла.ПолучитьОбласть(НомерПервойСтроки, 6).ТекущаяОбласть.Текст;
		СтрокаТоваров.ЦенаКМС = ТаблицаИзФайла.ПолучитьОбласть(НомерПервойСтроки, 7).ТекущаяОбласть.Текст;
		
		СсылкаНоменклатура = Справочники.Номенклатура.НайтиПоРеквизиту("Артикул", СтрокаТоваров.КодНоменклатуры);
		СсылкаГруппаНоменклатура = Справочники.Номенклатура.НайтиПоНаименованию(СтрокаТоваров.ГруппаНоменклатуры, Истина);
		
		СтрокаТоваров.НоменклатураСсылка = СсылкаНоменклатура;
		СтрокаТоваров.ГруппаНоменклатурыСсылка = СсылкаГруппаНоменклатура;
		
		НомерПервойСтроки = НомерПервойСтроки + 1;
	КонецЦикла; 

		
	//
КонецПроцедуры
