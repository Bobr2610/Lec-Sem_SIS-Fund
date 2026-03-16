В C# все функции являются компонентными, то есть их нельзя создать вне рамках объекта(?!)

Тип данных - класс или структура

static - определение на уровне типа, а не объекта. 
Теперь точка входа - статическая функция main.

Main с большой буквы!
Main ожидает массив строк. `string[] args`


Форматирование строк - для них класс string не использовать.
string - неизменяемый! Будет создаваться копия!
для этого используется String Builder. 


Простейшая программа на C#

```C#

using System;
namespace MySpace
{
	class Program
	{
		static void Main(string[] args)
		{
			Console.WriteLine("Пирвет, мир!");
		}
	}

}

```


*Garbage collector* начинает свою работу после вызова `operator new`


---

`class` - ключевое слово описания некоторой сущности из памяти
Конструктор класса - одноименный метод для инициализации объекта

```C#
class MyClass {...}

MyClass ob; // сслыка
ob = new MyClass(); // вызов конструктора
```

Свойства класса:
```C#
<type ret> PropName {
	set
	{
		value // значение, которое используется для инициализации полей класса
		// тип совпадает с типом свойства <type ...>
	}
	get
	{
		
		return <value>;
	}
}
```
```C#
class MyClass {
	int x;
	public int MyProperty {
		get
		{
			return;
		}
		set
		{
			if(value > 5)
				x = value;
			else(...)
		}
	}
}
```

```C#
MyClass ob1 = new ...;
ob1.MyProperty = 10; // обращение к свойству. Set method

tmp = obj1.MyProperty; // Get method
```

Это один из инструментов инкапсуляции.


Ключевое слово `abstract` - к методу или классу. На уровне данного класса не предполагается реализации. 

Ключевое слово `interface` - набор методов и свойств без реализации. Описываем прототипы свойств и методов.

```C#
interface MyInterface {
	double Foo1();
	int Foo2(double x);
	int Prop
	{
		get;
		set;
	}
}
```

Экземпляр абстрактного класса и интерфейса создать нельзя, но можно создать массив абстрактных классов или интерфейсов

```C#
MyInterface inter;

// Нельзя создать!
inter = new MyInterface();


MyInterface[] array;
```

```C#
array = new MyInterface[5]; // инициализация ссылки.
```

Ключевое слово `virtual` -  пишем всегда `override` 


```C#

class MyClass: MyInterface
{
	int x;
	
	public MyClass(){ ... }
	public MyClass(int x, double t) { ... }
	public double Foo1(){ ... }
	public int Foo2(double x){ ... }
	
	public int Prop{
		get { return 52; }
		set { x = value; }
	}
}
```

```C#
// В методе пишем

for (int i = 0; i < array.Length; ++i)
	array[i] = new MyClass( ... ); // Создаем объекты производного класса
	
foreach(var item in array) // var - аналог auto
	Console.WriteLine(item.Prop);
	// item = ... - НЕЛЬЗЯ!
```


Ключевое слово `base` для обращения к функционалу базового класса.

```C#
MyClass(int z): base(z) // Конструктор базового
{ ... }
```


`out, ref, params` - ключевые слова
`out` - соответствующий параметр метода - выходной
	Параметр `out` модифицируется телом функции.
`ref` - тело метода может модифицировать передаваемый аргумент, но за инициализацию отвечает вызывающий код











