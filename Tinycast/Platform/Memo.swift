/// A few-slot LRU memo; the key must name every dependency since nothing else invalidates a slot.
struct Memo<Key: Equatable, Value> {
    private var slots: [(key: Key, value: Value)] = []
    private let capacity: Int

    init(capacity: Int = 8) {
        precondition(capacity > 0, "Memo capacity must be positive")
        self.capacity = capacity
    }

    mutating func value(for key: Key, build: () -> Value) -> Value {
        if let index = slots.firstIndex(where: { $0.key == key }) {
            let hit = slots.remove(at: index)
            slots.append(hit)
            return hit.value
        }
        let built = build()
        if slots.count >= capacity { slots.removeFirst() }
        slots.append((key, built))
        return built
    }
}
