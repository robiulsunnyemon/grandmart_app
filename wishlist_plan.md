# ❤️ Grandmart Wishlist Feature — Professional Implementation Plan
### Industry Standard · GetX Architecture · CodeCanyon Ready

---

## 🎯 Scope & Goals

> **Wishlist** হলো authenticated user-এর favorite product collection।
> Guest user wishlist-এ add করতে গেলে → Login prompt দেখাবে।
> Wishlist data server-side persist হবে — device change করলেও থাকবে।

**এই plan-এ যা থাকবে:**
- Backend API (FastAPI) → Wishlist endpoints
- Flutter Data Layer → Model + Provider
- Global Service → `WishlistService` (GetX Singleton)
- UI Integration → Product Card, Product Detail, Bottom Nav, Wishlist Screen
- UX Patterns → Optimistic UI, Login Guard, Empty State, Animations

---

## 📐 Architecture Decision

```
┌─────────────────────────────────────────────────────┐
│                 WISHLIST ARCHITECTURE                │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ProductCard ──┐                                    │
│  ProductDetail─┤──▶ WishlistService (GetX Global)   │
│  WishlistView ─┘         ↕ API calls via            │
│                      WishlistProvider               │
│                          ↕                          │
│                   FastAPI Backend                   │
│                  /api/v1/wishlist                   │
└─────────────────────────────────────────────────────┘
```

> [!IMPORTANT]
> `WishlistService` একটিমাত্র GetX Global Singleton হবে — সব screen share করবে।
> `ProductCard`-এ wishlist button থাকবে, `WishlistController` আলাদা শুধু Wishlist Screen-এর জন্য।

---

## 🔌 PART 1 — Backend API (FastAPI)

### Database Model — `app/wishlist/model.py`

```python
class Wishlist(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="user.id", ondelete="CASCADE")
    product_id: int = Field(foreign_key="product.id", ondelete="CASCADE")
    created_at: datetime = Field(default_factory=datetime.utcnow)

    class Config:
        unique_together = [("user_id", "product_id")]  # Duplicate guard
```

### API Endpoints — `app/wishlist/router.py`

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `GET` | `/api/v1/wishlist` | ✅ Required | User-এর সব wishlist item |
| `POST` | `/api/v1/wishlist/{product_id}` | ✅ Required | Product add করা |
| `DELETE` | `/api/v1/wishlist/{product_id}` | ✅ Required | Product remove করা |
| `DELETE` | `/api/v1/wishlist` | ✅ Required | সব clear করা |
| `GET` | `/api/v1/wishlist/ids` | ✅ Required | শুধু product_id list (fast toggle check) |

### Response Schema

```python
# GET /wishlist → Full product details সহ
{
  "items": [
    {
      "id": 1,
      "product_id": 42,
      "added_at": "2026-08-06T00:00:00",
      "product": {
        "id": 42,
        "title": "Product Name",
        "thumbnail": "...",
        "price": 1200.0,
        "discount_price": 999.0
      }
    }
  ],
  "total": 5
}

# GET /wishlist/ids → Lightweight toggle check
{ "product_ids": [42, 17, 88] }

# POST /wishlist/42 → 201 Created
{ "message": "Added to wishlist", "product_id": 42 }

# DELETE /wishlist/42 → 200 OK
{ "message": "Removed from wishlist", "product_id": 42 }
```

---

## 📱 PART 2 — Flutter Implementation

### 🗂️ নতুন ফাইল Structure

```
lib/app/
│
├── data/
│   ├── models/
│   │   └── wishlist_model.dart         ← NEW (WishlistItem model)
│   └── providers/
│       └── wishlist_provider.dart      ← NEW (raw API calls)
│
├── core/
│   └── services/
│       └── wishlist_service.dart       ← NEW ★ Global Singleton Service
│
├── routes/
│   ├── app_routes.dart                 ← MODIFY (add WISHLIST route)
│   └── app_pages.dart                  ← MODIFY (register page)
│
├── modules/
│   ├── main_wrapper/
│   │   ├── controllers/main_wrapper_controller.dart  ← MODIFY (add tab)
│   │   └── views/main_wrapper_view.dart              ← MODIFY (add nav item)
│   │
│   ├── wishlist/                       ← NEW MODULE
│   │   ├── bindings/wishlist_binding.dart
│   │   ├── controllers/wishlist_controller.dart
│   │   └── views/wishlist_view.dart
│   │
│   ├── products/
│   │   └── product_detail/
│   │       └── views/product_detail_view.dart  ← MODIFY (wishlist button)
│   └── (home, categories, stores) — no changes needed
│
└── core/
    └── widgets/
        └── gm_product_card.dart        ← MODIFY (wishlist heart icon)
```

---

## 🧩 PART 3 — File-by-File Implementation Detail

---

### 1. `data/models/wishlist_model.dart` ← NEW

```dart
class WishlistItemModel {
  final int id;
  final int productId;
  final String addedAt;
  final ProductModel product;

  WishlistItemModel({...});

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {...}
}
```

---

### 2. `data/providers/wishlist_provider.dart` ← NEW

| Method | Action |
|--------|--------|
| `getWishlist()` | Full list with product details |
| `getWishlistIds()` | `List<int>` — fast lookup |
| `addToWishlist(int productId)` | POST |
| `removeFromWishlist(int productId)` | DELETE |
| `clearWishlist()` | DELETE all |

---

### 3. `core/services/wishlist_service.dart` ← NEW ★ (সবচেয়ে গুরুত্বপূর্ণ)

```dart
class WishlistService extends GetxService {
  // Global reactive wishlist product IDs set
  final _wishlistIds = <int>{}.obs;  // RxSet for O(1) lookup

  bool isWishlisted(int productId) => _wishlistIds.contains(productId);
  int get count => _wishlistIds.length;

  // Called on app startup (if logged in)
  Future<void> fetchIds() async { ... }

  // Toggle with Optimistic UI
  Future<void> toggle(int productId) async {
    final wasWishlisted = isWishlisted(productId);

    // 1. Optimistic update (instant UI feedback)
    if (wasWishlisted) {
      _wishlistIds.remove(productId);
    } else {
      _wishlistIds.add(productId);
    }

    // 2. API call
    try {
      if (wasWishlisted) {
        await _provider.removeFromWishlist(productId);
      } else {
        await _provider.addToWishlist(productId);
      }
    } catch (e) {
      // 3. Rollback on failure
      if (wasWishlisted) {
        _wishlistIds.add(productId);
      } else {
        _wishlistIds.remove(productId);
      }
      Get.snackbar('Error', 'Could not update wishlist');
    }
  }
}
```

> [!TIP]
> **Optimistic UI Pattern** — API call-এর আগেই UI update হয়। User দেখে instant response।
> API fail করলে rollback হয়। এটাই industry standard (Amazon, Daraz সব করে এটা)।

---

### 4. `core/widgets/gm_product_card.dart` ← MODIFY

Heart icon সহ product card:

```
┌────────────────────┐
│   [Product Image]  │  ← Top-right: ❤️ Heart icon (Obx reactive)
│   [OFFER] [★]      │
├────────────────────┤
│ Product Title      │
│ ৳999  ~~৳1200~~   │
└────────────────────┘
```

- **Heart icon:** `Obx(() => Icon(WishlistService.to.isWishlisted(product.id) ? Icons.favorite : Icons.favorite_border))`
- **Tap behavior:**
  - Logged in → `WishlistService.to.toggle(product.id)`
  - Guest → `Get.toNamed(Routes.LOGIN)` with snackbar "Login to save favorites"
- **Animation:** `AnimatedSwitcher` — fill/unfill animation on tap

---

### 5. `modules/wishlist/` ← NEW MODULE

#### Wishlist Screen Layout

```
┌──────────────────────────────────────┐
│  ❤️ My Wishlist        [Clear All ×] │  ← AppBar
├──────────────────────────────────────┤
│                                      │
│  ┌──────────┐  ┌──────────┐         │
│  │[Product] │  │[Product] │         │  ← Responsive Grid (same as product list)
│  │  ❤️ filled│  │  ❤️ filled│        │
│  │ ৳999     │  │ ৳450     │         │
│  └──────────┘  └──────────┘         │
│                                      │
│  ┌──────────┐  ┌──────────┐         │
│  │[Product] │  │[Product] │         │
│  └──────────┘  └──────────┘         │
│                                      │
├──────────────────────────────────────┤
│  [Empty state — Lottie if empty]     │
└──────────────────────────────────────┘
```

#### WishlistController

```dart
class WishlistController extends GetxController {
  final wishlistItems = <WishlistItemModel>[].obs;
  final isLoading = true.obs;

  void fetchWishlist() async { ... }
  void removeItem(int productId) async { ... }  // Also calls WishlistService.toggle
  void clearAll() async { ... }
}
```

---

### 6. Bottom Nav — MODIFY

> [!IMPORTANT]
> Wishlist tab Bottom Nav-এ যোগ হবে।
> `AppConfig`-এ `showWishlistTab` flag যোগ করা হবে।
> Badge counter দেখাবে যদি item থাকে।

```
Home | Categories | Products | Wishlist(3) | Stores
  🏠       ⊞          🛍️        ❤️ ³         🏪
```

**Wishlist Badge:** `Stack` + `Positioned` দিয়ে item count badge:
```dart
Stack(
  children: [
    Icon(Icons.favorite_border),
    if (count > 0)
      Positioned(
        right: 0, top: 0,
        child: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          child: Text('$count', style: TextStyle(fontSize: 10, color: Colors.white)),
        ),
      ),
  ],
)
```

---

## ⚡ PART 4 — UX Flows (Industry Standard)

### Flow 1: Guest User tries to Wishlist
```
Guest presses ❤️
      ↓
SnackBar: "Login to save your favorites"
      ↓ (action button)
Navigate to LoginView
      ↓ (after login)
Return to previous screen
      ↓
Auto-trigger wishlist toggle
```

### Flow 2: Logged-in User Toggle
```
User presses ❤️
      ↓
[Optimistic] Heart fills/unfills instantly
      ↓
[Background] API call
      ↓ success      ↓ failure
State stays    Rollback + Snackbar
```

### Flow 3: App Start (Logged-in)
```
main() → StorageService.isLoggedIn == true
      ↓
WishlistService.fetchIds() called in background
      ↓
All product cards immediately know wishlist state
```

---

## 📋 PART 5 — Execution Steps

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 BACKEND (FastAPI)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP B-1  app/wishlist/model.py     ← SQLModel + unique constraint
STEP B-2  app/wishlist/schema.py    ← Pydantic request/response schemas
STEP B-3  app/wishlist/router.py    ← 5 endpoints
STEP B-4  main.py                   ← router register

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 FLUTTER (Foundation)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP F-1  api_config.dart           ← wishlist endpoints add
STEP F-2  wishlist_model.dart       ← Dart model class
STEP F-3  wishlist_provider.dart    ← Dio API calls
STEP F-4  wishlist_service.dart     ← Global RxSet service
STEP F-5  main.dart                 ← WishlistService init (if logged in)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 FLUTTER (UI Integration)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP F-6  gm_product_card.dart      ← Heart icon + AnimatedSwitcher
STEP F-7  product_detail_view.dart  ← Large heart button in AppBar
STEP F-8  app_config.dart           ← showWishlistTab flag
STEP F-9  app_routes.dart           ← WISHLIST route add
STEP F-10 modules/wishlist/         ← binding, controller, view
STEP F-11 main_wrapper/             ← Wishlist tab + badge counter
```

---

## ✅ Definition of Done (DoD)

একটি feature "সম্পন্ন" বলা যাবে যখন:

- [ ] Guest user → Login guard কাজ করে
- [ ] Product Card-এ heart icon reactively toggle করে
- [ ] Product Detail-এ heart button কাজ করে
- [ ] Wishlist Screen-এ সব saved product দেখায়
- [ ] Item remove করা যায় (card + swipe gesture)
- [ ] Clear All কাজ করে (confirmation dialog সহ)
- [ ] Bottom Nav badge count live update করে
- [ ] App restart করলেও wishlist data থাকে (server-side)
- [ ] API fail হলে Optimistic rollback কাজ করে
- [ ] Empty state দেখায় when wishlist is empty
- [ ] Responsive (Phone → Tablet grid)

---

## 🚀 Proceed করব?

> "Proceed" চাপলে আমি **Backend → Flutter** ক্রমে সব ফাইল implement করব।
