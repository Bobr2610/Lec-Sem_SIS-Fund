# Билет 12: Сбалансированные по высоте деревья поиска и B-деревья

Полный ответ на 12-й вопрос билета: включает архитектуру, описание алгоритмов и кодовые примеры на C++ для поворотов АВЛ-деревьев и базовых операций B-семейства.

---

## 1. Сбалансированные по высоте деревья поиска (АВЛ-деревья)

**АВЛ-дерево** — это двоичное дерево поиска, для которого выполняется свойство сбалансированности по высоте: для любой вершины дерева высота её правого поддерева отличается от высоты левого поддерева не более чем на 1.
Показатель баланса (Balance Factor, BF) = Высота(Левого поддерева) - Высота(Правого поддерева). Допустимые значения: -1, 0, 1.

### Полный спектр операций над АВЛ-деревом:
1. **Поиск (Search) O(log n)**: Стандартный бинарный поиск.
2. **Вставка (Insert) O(log n)**: Стандартная вставка, после которой происходит возврат вверх к корню с пересчетом баланса (BF) и выполнением поворотов при $|BF| > 1$.
3. **Удаление (Delete) O(log n)**: Удаление узла с последующим подъемом вверх к корню с балансировкой (может потребовать до $O(\log n)$ поворотов).
4. **Поиск минимума/максимума (Find Min/Max) O(log n)**: Спуск максимально влево или вправо.
5. **Поиск следующего/предыдущего (Successor/Predecessor) O(log n)**.
6. **Обход (Traversal) O(n)**: In-order, Pre-order и Post-order.

### Архитектура узла и функции высоты
```cpp
#include <algorithm>

template <typename Key>
struct AVLNode {
    Key key;
    int height;
    AVLNode* left;
    AVLNode* right;
};

int height(AVLNode<Key>* node) { return node ? node->height : 0; }
void updateHeight(AVLNode<Key>* node) {
    if (node) node->height = 1 + std::max(height(node->left), height(node->right));
}
```

### Операции поворотов (для восстановления баланса)

*Примечание: "Большой левый" синонимичен "Двойному право-левому", а "Большой правый" — "Двойному лево-правому".*

```cpp
// 1. МАЛЫЙ ПРАВЫЙ ПОВОРОТ (Small Right Rotation / LL-случай)
// Выполняется, если левое поддерево выше правого на 2, и дисбаланс вызван левым потомком левого узла.
AVLNode<Key>* smallRightRotate(AVLNode<Key>* y) {
    AVLNode<Key>* x = y->left;
    y->left = x->right;
    x->right = y;
    
    updateHeight(y);
    updateHeight(x);
    return x; // x - новый корень
}

// 2. МАЛЫЙ ЛЕВЫЙ ПОВОРОТ (Small Left Rotation / RR-случай)
// Выполняется, если правое поддерево выше левого на 2, и дисбаланс вызван правым потомком правого узла.
AVLNode<Key>* smallLeftRotate(AVLNode<Key>* x) {
    AVLNode<Key>* y = x->right;
    x->right = y->left;
    y->left = x;
    
    updateHeight(x);
    updateHeight(y);
    return y; // y - новый корень
}

// 3. ДВОЙНОЙ / БОЛЬШОЙ ПРАВЫЙ ПОВОРОТ (LR-случай)
// Малый левый поворот для левого потомка, затем малый правый для текущего узла.
AVLNode<Key>* bigRightRotate(AVLNode<Key>* node) {
    node->left = smallLeftRotate(node->left);
    return smallRightRotate(node);
}

// 4. ДВОЙНОЙ / БОЛЬШОЙ ЛЕВЫЙ ПОВОРОТ (RL-случай)
// Малый правый поворот для правого потомка, затем малый левый для текущего узла.
AVLNode<Key>* bigLeftRotate(AVLNode<Key>* node) {
    node->right = smallRightRotate(node->right);
    return smallLeftRotate(node);
}
```

---

## 2. Архитектура семейства B-деревьев

B-дерево и его вариации — это сильно ветвящиеся сбалансированные деревья, разработанные для оптимизации хранения данных на диске.

### Базовые низкоуровневые операции:
*   **Сплит (Split)**: При переполнении узла он делится на два. Дерево растет вверх.
*   **Мердж (Merge)**: При удалении, если узлы заполнены меньше минимума, два соседних сливаются в один.
*   **Заимствование / Перераспределение (Borrow/Redistribute)**: Элемент "перетекает" от переполненного соседа к текущему через родителя.

### Спецификации разных B-деревьев:
1. **B-дерево**: Ключи и данные хранятся везде (и в корнях, и в листьях). Узел должен быть заполнен минимум на 1/2.
2. **B+ дерево**: Все данные хранятся **только в листьях**. Внутренние узлы — лишь индексы-маршрутизаторы. Листья связаны в **список** для сверхбыстрого поиска в диапазоне.
3. **B* дерево**: Версия B-дерева, где узлы заполнены минимум на **2/3**. При переполнении сначала делается **redistribute** с братом, и только если оба полны — сплит (2 узла бьются на 3).
4. **B*+ дерево**: Объединяет B+ (данные только в листьях, листья в списке) и B* (заполнение 2/3, перераспределение вместо немедленного сплита).

### Унифицированная структура узла

```cpp
#include <vector>

template <typename Key>
struct BNode {
    bool is_leaf;
    std::vector<Key> keys;
    std::vector<BNode*> children; // Для внутренних узлов
    BNode* next_leaf;             // Только для B+ / B*+ деревьев
};
```

### Кодовые операции B-деревьев

**1. Поиск элемента по ключу (Общий для всех В-деревьев)**
```cpp
BNode<Key>* searchKey(BNode<Key>* node, Key target) {
    if (!node) return nullptr;
    int i = 0;
    while (i < node->keys.size() && target > node->keys[i]) i++;
    if (i < node->keys.size() && node->keys[i] == target) return node; 
    if (node->is_leaf) return nullptr;
    return searchKey(node->children[i], target);
}
```

**2. Поиск в диапазоне ключей (B+ и B*+)**
```cpp
std::vector<Key> rangeSearch(BNode<Key>* root, Key start, Key end) {
    std::vector<Key> result;
    if (!root) return result;

    // Спуск к листу за O(log N)
    BNode<Key>* curr = root;
    while (!curr->is_leaf) {
        int i = 0;
        while (i < curr->keys.size() && start > curr->keys[i]) i++;
        curr = curr->children[i];
    }

    // Проход по связному списку листьев
    while (curr != nullptr) {
        for (int i = 0; i < curr->keys.size(); i++) {
            if (curr->keys[i] >= start && curr->keys[i] <= end) result.push_back(curr->keys[i]);
            if (curr->keys[i] > end) return result; // Оптимизация выхода
        }
        curr = curr->next_leaf;
    }
    return result;
}
```

**3. Операции добавления (Сплит и Перераспределение)**
```cpp
// B и B+ дерево: Сплит узла
void splitChild(BNode<Key>* parent, int child_idx) {
    BNode<Key>* old_node = parent->children[child_idx];
    BNode<Key>* new_node = new BNode<Key>{old_node->is_leaf};
    
    if (old_node->is_leaf) { // Поддержка списка B+ дерева
        new_node->next_leaf = old_node->next_leaf;
        old_node->next_leaf = new_node;
    }
    // ... логика разделения пополам (t элементов) ...
    int t = old_node->keys.size() / 2;
    parent->keys.insert(parent->keys.begin() + child_idx, old_node->keys[t]);
    parent->children.insert(parent->children.begin() + child_idx + 1, new_node);
}

// B* и B*+ дерево: Перераспределение (Redistribute) 
bool redistribute(BNode<Key>* parent, int child_idx) {
    BNode<Key>* node = parent->children[child_idx];
    if (child_idx < parent->children.size() - 1) {
        BNode<Key>* right_sibling = parent->children[child_idx + 1];
        if (!right_sibling_is_full) { // Условное поле
            right_sibling->keys.insert(right_sibling->keys.begin(), node->keys.back());
            node->keys.pop_back();
            parent->keys[child_idx] = right_sibling->keys.front(); // Обновление родителя
            return true;
        }
    }
    return false; // Требуется Split 2 в 3
}
```

**4. Операции удаления (Заимствование и Слияние)**
```cpp
// Заимствование (Borrow) у левого брата
void borrowFromPrev(BNode<Key>* parent, int child_idx) {
    BNode<Key>* node = parent->children[child_idx];
    BNode<Key>* left_sibling = parent->children[child_idx - 1];

    node->keys.insert(node->keys.begin(), parent->keys[child_idx - 1]);
    parent->keys[child_idx - 1] = left_sibling->keys.back();
    left_sibling->keys.pop_back();
}

// Слияние (Merge) с правым братом
void mergeNodes(BNode<Key>* parent, int child_idx) {
    BNode<Key>* left = parent->children[child_idx];
    BNode<Key>* right = parent->children[child_idx + 1];

    left->keys.push_back(parent->keys[child_idx]); // Ключ из родителя
    for (auto k : right->keys) left->keys.push_back(k);
    
    if (left->is_leaf) left->next_leaf = right->next_leaf; // Поддержка B+

    parent->keys.erase(parent->keys.begin() + child_idx);
    parent->children.erase(parent->children.begin() + child_idx + 1);
    delete right;
}
```