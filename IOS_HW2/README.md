Question: What issues prevent us from using storyboards in real projects? Когда большое кол-во компонентов нужно создавать, то могут возникнуть проблемы + так сложнее разрабатывать в команде и изминять интерфейс

Question: What does the code on lines 25 and 29 do? Строка 25: Отключает автоматическую конвертацию констрейнтов. Констрейнтер - это правила, которые определяют размер и положение view на экране относительно других элементов на любых устройствах. Строка 29: Добавляет label в иерархию view для отображения на экране.

Question: What is a safe area layout guide? Зона экрана свободная от системных элементах (тип индикатор зарядки и тд) Зона, за границы которой желательно не уходить при разработке

Question: What is [weak self] on line 23 and why it is important? Создает слабую ссылку на self внутри замыкания для предотвращения цикла сильных ссылок и утечки памяти. Это типо weak_ptr в C++, чтобы избежать утечек памяти

Question: What does clipsToBounds mean? Если тру, то вся длина/ширина, выходящая за размеры родителя, будет обрезана

Question: What is the valueChanged type? What is Void and what is Double? Тип valueChanged: ((Double) -> Void)?. Double - тип принимаемого значения, Void - означает, что замыкание ничего не возвращает.
