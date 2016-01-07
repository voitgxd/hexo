title: "Guava-Collection'"
date: 2016-01-07 16:07:56
tags: [java,guava]
categories: Guava
---
Guava致力于提升常见任务的开发效率，每天学习多一点，避免重复早轮子，记录下Guava学习之Guava Collection API常用特性。

<!--more-->

一.不可变集合
google提供的集合不变性有如下优点：
 <li>数据不可改变</li>
<li>线程安全</li>
<li>不需要同步逻辑</li>
 <li>可以被自由的共享</li>
<li>容易设计和实现</li>
 <li>内存和时间高效</li>

不变集合的创建方法：

```
ImmutableSet<Integer> numbers = ImmutableSet.of(10, 20, 30, 40, 50);
//使用copyOf方法
ImmutableSet<Integer> another = mmutableSet.copyOf(numbers);
//使用Builder方法
ImmutableSet<Integer> numbers2 = ImmutableSet.<Integer>builder().addAll(numbers) .add(60) .add(70).add(80).build();
```
如果针对annother再执行put操作，则会提示如下异常：java.lang.UnsupportedOperationException。
二.新的集合类型
1.MultiMap
一种key可以重复的map，子类有ListMultimap和SetMultimap，对应的通过key分别得到list和set

```
Multimap<String, Person> customersByType =ArrayListMultimap.create();customersByType.put("abc", new Person(1, 1, "a", "46546", 1, 20));
customersByType.put("abc", new Person(1, 1, "a", "46546", 1, 30));
customersByType.put("abc", new Person(1, 1, "a", "46546", 1, 40));
customersByType.put("abc", new Person(1, 1, "a", "46546", 1, 50));
customersByType.put("abcd", new Person(1, 1, "a", "46546", 1, 50));
customersByType.put("abcde", new Person(1, 1, "a", "46546", 1, 50));
for(Person person:customersByType.get("abc")){
	System.out.println(person.getAge());
}
```

2.MultiSet
不是集合，可以增加重复的元素，并且可以统计出重复元素的个数

```
Multiset<Integer> multiSet = HashMultiset.create();
multiSet.add(10);
multiSet.add(30);
multiSet.add(30);
multiSet.add(40);
System.out.println(multiSet.count(30)); // 2
System.out.println(multiSet.size());	//4
```

3.Table
相当于有两个key的map，适用于有两个约束条件唯一确定的元素

```
Table<Integer,Integer,Person> personTable=HashBasedTable.create();
personTable.put(1,20,new Person(1, 1, "a", "46546", 1, 20));
personTable.put(0,30,new Person(2, 1, "ab", "46546", 0, 30));
personTable.put(0,25,new Person(3, 1, "abc", "46546", 0, 25));
personTable.put(1,50,new Person(4, 1, "aef", "46546", 1, 50));
personTable.put(0,27,new Person(5, 1, "ade", "46546",0, 27));
personTable.put(1,29,new Person(6, 1, "acc", "46546", 1, 29));
personTable.put(0,33,new Person(7, 1, "add", "46546",0, 33));
personTable.put(1,66,new Person(8, 1, "afadsf", "46546", 1, 66));
//1,得到行集合
Map<Integer,Person> rowMap= personTable.row(0);
int maxAge= Collections.max(rowMap.keySet());
```

4.BiMap
是一个一一双向映射Map，可以通过key得到value，也可以通过value得到key

```
BiMap<Integer,String> biMap=HashBiMap.create();
biMap.put(1,"hello");
biMap.put(2,"helloa");
biMap.put(3,"world");
biMap.put(4,"worldb");
biMap.put(5,"my");
biMap.put(6,"myc");
int value= biMap.inverse().get("my");
System.out.println(value);//my
```
三、谓词和筛选
谓词是用来筛选集合的，谓词是一个简单的接口，只有一个方法，返回布尔值。需结合collections2.filter方法使用，这个筛选方法返回原来的集合中满足这个谓词接口的元素。
		

```
   public static void main(String[] args) {
	    Optional<ImmutableMultiset<Student>> optional = Optional
				.fromNullable(testPredict());
		if (optional.isPresent()) {
			for (Student p : optional.get()) {
				System.out.println("年龄为0的学生：" + p);
			}
		}
		System.out.println(optional.isPresent());
	}

	public static ImmutableMultiset<Student> testPredict() {
		List<Student> StudentList = Lists.newArrayList(
				new Student("a", 1),
				new Student("ab", 30),
				new Student("abc", 0),
				new Student("aef", 50),
				new Student("ade", 27),
				new Student("acc",0),
				new Student("add", 0));

		return ImmutableMultiset.copyOf(Collections2.filter(StudentList,
				new Predicate<Student>() {
					public boolean apply(Student input) {
						return input.getAge() == 0;
					}
				}));
	}
```
四、集合排序

```
@Test
	public void testOrder(){
		List<Integer> numbers = Lists.newArrayList(30, 20, 60, 80, 10);
		System.out.println(Ordering.natural().sortedCopy(numbers)); //10,20,30,60,80
		System.out.println(Ordering.natural().reverse().sortedCopy(numbers)); //80,60,30,20,10
		System.out.println(Ordering.natural().min(numbers)); //10
		System.out.println(Ordering.natural().max(numbers)); //80
		numbers = Lists.newArrayList(30, 20, 60, 80, null, 10);
		System.out.println(Ordering.natural().nullsLast().sortedCopy(numbers)); //10, 20,30,60,80,null
		System.out.println(Ordering.natural().nullsFirst().sortedCopy(numbers)); //null,10,20,30,60,80
	}
```
