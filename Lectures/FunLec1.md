# Лекция 1 (C#)

В C# все функции являются компонентными, то есть их нельзя создать вне рамок объекта.

- Тип данных: класс или структура
- `static` — определение на уровне типа, а не объекта
- Точка входа — статическая функция `Main`
- `Main` ожидает массив строк: `string[] args`

Форматирование строк:

- `string` неизменяемый, при изменении создается копия
- Для сборки строк используйте `StringBuilder`

## Простейшая программа на C#

```csharp
using System;

namespace MySpace
{
	class Program
	{
		static void Main(string[] args)
		{
			Console.WriteLine("Привет, мир!");
		}
	}
}
```

*Garbage collector* начинает свою работу после вызова `operator new`.

---

`class` — ключевое слово описания сущности в памяти.
Конструктор класса — одноименный метод для инициализации объекта.

```csharp
class MyClass { ... }

MyClass ob; // ссылка
ob = new MyClass(); // вызов конструктора
```

## Свойства класса

```csharp
<type ret> PropName
{
	set
	{
		value; // значение, используемое для инициализации полей класса
		// тип совпадает с типом свойства <type ...>
	}
	get
	{
		return <value>;
	}
}
```

```csharp
class MyClass
{
	int x;

	public int MyProperty
	{
		get
		{
			return;
		}
		set
		{
			if (value > 5)
				x = value;
			else (...)
		}
	}
}
```

```csharp
MyClass ob1 = new ...;
ob1.MyProperty = 10; // обращение к свойству: set

tmp = obj1.MyProperty; // обращение к свойству: get
```

Это один из инструментов инкапсуляции.

`abstract` — к методу или классу. На уровне данного класса не предполагается реализации.

`interface` — набор методов и свойств без реализации (прототипы свойств и методов).

```csharp
interface MyInterface
{
	double Foo1();
	int Foo2(double x);
	int Prop
	{
		get;
		set;
	}
}
```

Экземпляр абстрактного класса и интерфейса создать нельзя, но можно создать массив абстрактных классов или интерфейсов.

```csharp
MyInterface inter;

// Нельзя создать
inter = new MyInterface();

MyInterface[] array;
```

```csharp
array = new MyInterface[5]; // инициализация ссылки
```

`virtual` — при переопределении всегда пишем `override`.

```csharp
class MyClass : MyInterface
{
	int x;

	public MyClass() { ... }
	public MyClass(int x, double t) { ... }
	public double Foo1() { ... }
	public int Foo2(double x) { ... }

	public int Prop
	{
		get { return 52; }
		set { x = value; }
	}
}
```

```csharp
// В методе пишем
for (int i = 0; i < array.Length; ++i)
	array[i] = new MyClass(...); // создаем объекты производного класса

foreach (var item in array) // var - аналог auto
	Console.WriteLine(item.Prop);
	// item = ... - нельзя
```

`base` — обращение к функционалу базового класса.

```csharp
MyClass(int z) : base(z) // конструктор базового класса
{ ... }
```

`out`, `ref`, `params` — ключевые слова.

- `out` — выходной параметр, модифицируется телом функции
- `ref` — тело метода может модифицировать передаваемый аргумент, но за инициализацию отвечает вызывающий код











