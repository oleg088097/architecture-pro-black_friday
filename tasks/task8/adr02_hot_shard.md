### <a name="_b7urdng99y53"></a>**Название задачи:** Выявление и устранение «горячих» шардов
### <a name="_hjk0fkfyohdk"></a>**Автор:** Кузьмин О.О.
### <a name="_uanumrh8zrui"></a>**Дата:** 06.02.2026
### <a name="_3bfxc9a45514"></a>**Контекст**

Из-за категории «Электроника» произошла перегрузка одного из шардов MongoDB, так как 70% запросов приходилось именно на эти товары. 
Поэтому сейчас нужно разработать стратегию, как выявлять и устранять такие «горячие» шарды, а ещё предложить метрики мониторинга, чтобы в будущем можно было предотвращать такие ситуации.

### <a name="_qmphm5d6rvi3"></a>**Решение**

#### 1. Состояние шардов
Для отслеживания состояния шардов можно использовать команду getShardDistribution
Документация: https://www.mongodb.com/docs/manual/reference/method/db.collection.getShardDistribution/

Пример команды:
```mongodb-json
db.products.getShardDistribution()
```

Полное описание параметров и метрик можно прочитать в документации. 
Полезными будут метрики, указывающие на равномерность распределение данных между шардами и чанками:
- data
- docs

#### 2. Собрать данные по запросам в базе данных.
Для более глубокого изучения шардов нужно сконфигурировать анализ запросов командой configureQueryAnalyzer. 
Документация: https://www.mongodb.com/docs/manual/reference/command/configureQueryAnalyzer

Пример команды:
```mongodb-json
db.products.configureQueryAnalyzer(
   {
      mode: "full",
      samplesPerSecond: 5
   }
)
```

#### 3. Анализ ключа шардинга
После сбора данных по запросам можно выполнять команду анализа ключа командой analyzeShardKey.

Документация: https://www.mongodb.com/docs/manual/reference/command/analyzeShardKey/

Пример команды:
```mongodb-json
db.products.analyzeShardKey(
   { category: 1 },
   {
      keyCharacteristics: true,
      readWriteDistribution: false,
   }
)
```

Полное описание параметров и метрик можно прочитать в документации. 
Для отслеживания состояния шардов пригодятся метрики, указывающие на распределение операций чтения-записи между шардами.
- percentageOfScatterGatherReads
- numReadsByRange
- percentageOfScatterGatherWrites
- numWritesByRange

Кроме того, можно использовать метрики, которые показывают распределение значений для выбранного ключа шардирования:
- keyCharacteristics.mostCommonValues
- keyCharacteristics.monotonicity

#### 4. Устранение дисбаланса 

В MongoDB по умолчанию включен процесс балансировки для шардированных коллекций.
1) Его можно настроить.
https://www.mongodb.com/docs/manual/reference/command/configureCollectionBalancing/
2) Можно добавить узел шардирования.
https://www.mongodb.com/docs/manual/reference/command/addShard/

В ситуациях, когда один чанк не может быть разделён для балансировки, он отмечается как jumbo и автоматическая балансировка не способна его перенести. В таком случае можно:
3) Добавить к существующему ключу шардирования новые поля в качестве суффикса refineCollectionShardKey.
https://www.mongodb.com/docs/manual/reference/command/refineCollectionShardKey/
4) Сменить ключ шардирования на более разнообразный.
https://www.mongodb.com/docs/manual/reference/command/reshardCollection/

### <a name="_bjrr7veeh80c"></a>**Последствия**
