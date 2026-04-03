16/03/2026

# Длинные числа

Хабр от майкр для C# https://habr.com/ru/articles/207754/

Реализация https://brestprog.by/topics/longarithmetics/

Нужно учитывать Big/Litlle-endian

умножение Карацуба https://ru.wikipedia.org/wiki/%D0%90%D0%BB%D0%B3%D0%BE%D1%80%D0%B8%D1%82%D0%BC_%D0%9A%D0%B0%D1%80%D0%B0%D1%86%D1%83%D0%B1%D1%8B


## Записи

### **Карацуба**

$$
\left.\begin{aligned}
A &= a_0 + a_1x + \dots + a_{n-1}x^{n-1} \\
B &= b_0 + b_1x + \dots + b_{n-1}x^{n-1}
\end{aligned}\right\} \begin{array}{l} \text{представление числа} \\ \text{как полином} \end{array}
$$

$$
\left.\begin{aligned}
A_0 &= a_0 + a_1x + \dots + a_{n/2 - 1}x^{n/2 - 1} \\
A_1 &= a_{n/2} + a_{n/2 + 1}x + \dots + a_{n - 1}x^{n/2 - 1}
\end{aligned}\right\} \underbrace{A = A_0 + A_1x^{n/2}}_{\substack{\text{как раз работа} \\ \text{в половинках}}}
$$

$$
\left.\begin{aligned}
B_0 &= b_0 + b_1x + \dots + b_{n/2 - 1}x^{n/2 - 1} \\
B_1 &= b_{n/2} + b_{n/2 + 1}x + \dots + b_{n - 1}x^{n/2 - 1}
\end{aligned}\right\} B = B_0 + B_1x^{n/2}
$$

**Умножение $A \cdot B$:**

$$A \cdot B = (A_0 + x^{n/2}A_1)(B_0 + x^{n/2}B_1) =$$

$$= A_0B_0 + A_0x^{n/2}B_1 + x^{n/2}A_1B_0 + A_1B_1x^n =$$

$$= A_0B_0 + x^{n/2}(A_0B_1 + A_1B_0) + A_1B_1x^n$$

$\swarrow$
$$A_0B_1 + A_1B_0 = (A_0 + A_1)(B_0 + B_1) - A_0B_0 - A_1B_1$$

*(Итоговая формула после подстановки):*
$$= A_0B_0 + x^{n/2}[(A_0 + A_1)(B_0 + B_1) - A_0B_0 - A_1B_1] + A_1B_1x^n$$

$4$ умножения $\rightarrow$ $3$ умножения
Сложность $O(n^{\log_2 3})$
