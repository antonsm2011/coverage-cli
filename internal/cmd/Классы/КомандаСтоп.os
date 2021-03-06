
#Область КомандаПриложения

Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Опция("p pid", 0, "Идентификатор процесса")
		.ТЧисло();	

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ОписаниеТиповЧисло = Новый ОписаниеТипов("Число");
	Лог = ПараметрыПриложения.Лог();
	Если Команда.ЗначениеОпции("debug") Тогда
		ПараметрыПриложения.ВключитьРежимОтладки();
	КонецЕсли;

	ПараметрИдентификаторПроцесса = Команда.ЗначениеОпции("pid");

	МассивФайловPID = НайтиФайлы(КаталогВременныхФайлов(), "coverage.*.pid");
	Если МассивФайловPID.Количество() = 0 Тогда
		Лог.Предупреждение("Не найдены pid файлы");
		Возврат;
	КонецЕсли;

	Для Каждого ФайлPID Из МассивФайловPID Цикл

		Массив = СтрРазделить(ФайлPID.ИмяБезРасширения, "."); 
		Если Массив.Количество() <> 2 Тогда
			Лог.Отладка(СтрШаблон("Файл не является pid-файлом: %1", ФайлPID.ПолноеИмя));
			УдалитьФайлы(ФайлPID.ПолноеИмя);
			Продолжить;
		КонецЕсли;
		
		ИдентификаторПроцесса = ОписаниеТиповЧисло.ПривестиЗначение(Массив[1]);
		Если ИдентификаторПроцесса = 0 Тогда
			Лог.Отладка(СтрШаблон("Идентификатор процесса не является pid: %1", ФайлPID.ПолноеИмя));
			УдалитьФайлы(ФайлPID.ПолноеИмя);
			Продолжить;
		КонецЕсли;

		Процесс = НайтиПроцессПоИдентификатору(ИдентификаторПроцесса);
		Если Процесс = Неопределено Тогда
			Лог.Отладка(СтрШаблон("Процесс из pid-файла не найден: %1", ФайлPID.ПолноеИмя));
			УдалитьФайлы(ФайлPID.ПолноеИмя);
			Продолжить;
		КонецЕсли;

		Если ЗначениеЗаполнено(ПараметрИдентификаторПроцесса) И ИдентификаторПроцесса <> ПараметрИдентификаторПроцесса Тогда
			Продолжить;
		КонецЕсли;		 

		Лог.Информация(СтрШаблон("Завершаем процесс из pid-файла: %1", ФайлPID.ПолноеИмя));
		Попытка
			Процесс.Завершить();
			Лог.Отладка(СтрШаблон("Процесс из pid-файла завершен: %1", ФайлPID.ПолноеИмя));
		Исключение
			Лог.Предупреждение(СтрШаблон("Процесс из pid-файла не завершен: %1", ФайлPID.ПолноеИмя));
		КонецПопытки;

		УдалитьФайлы(ФайлPID.ПолноеИмя);

	КонецЦикла;

КонецПроцедуры

#КонецОбласти
