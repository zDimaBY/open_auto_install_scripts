<?php
$file = 'counters.json';

// Функція для отримання поточного значення лічильника
function getCurrentCount($file, $counterIndex) {
    // Перевірка та створення файлу лічильників
    if (!file_exists($file)) {
        // Ініціалізуємо лічильники з нулями
        $initialCounts = array_fill(0, 9, 0); // 9 лічильників, починаючи з нуля
        file_put_contents($file, json_encode($initialCounts));
    }

    // Отримання всіх лічильників
    $counters = json_decode(file_get_contents($file), true);
    
    // Перевірка коректності номера лічильника
    if ($counterIndex >= 0 && $counterIndex < count($counters)) {
        return $counters[$counterIndex];
    } else {
        // Використовуємо загальний лічильник, якщо номер некоректний
        return $counters[0];
    }
}

// Отримання номера лічильника з GET параметру
$counterIndex = isset($_GET['counter']) ? intval($_GET['counter']) : 0;

// Отримання поточного значення лічильника
$currentCount = getCurrentCount($file, $counterIndex);
echo $currentCount;
?>
