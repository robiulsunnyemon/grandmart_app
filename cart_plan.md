# 🛒 Grandmart Add to Cart & Cart Module — Professional Implementation Plan
### Multi-Vendor Ready · Hybrid State (Guest + DB) · CodeCanyon Standard · GetX Architecture

---

## 🎯 Scope & Core Requirements

> **Cart System** হলো ই-কমার্স অ্যাপের হৃদপিণ্ড। multi-vendor ই-কমার্সে Cart ম্যানেজমেন্ট সাধারণ e-commerce থেকে কিছুটা ভিন্ন, কারণ প্রোডাক্ট বিভিন্ন Vendor Store থেকে আসে।

**প্রধান বৈচিত্র্যময় ফিচারসমূহ:**
1. **Hybrid Syncing (Guest + User):**
   - **Guest User:** কার্ট লোকালি `GetStorage`-এ সেভ থাকবে।
   - **Logged-in User:** কার্ট FastAPI Backend Database-এ পারসিস্ট হবে।
   - **On-Login Merge:** গেস্ট ইউজার লগইন করার সাথে সাথে লোকাল কার্ট আইটেম সার্ভারের কার্টের সাথে মার্জ (Merge) হয়ে যাবে।
2. **Multi-Vendor Grouping:** Cart Screen-এ প্রোডাক্টগুলো Vendor Store ভিত্তিক গ্রুপ হয়ে দেখাবে।
3. **Variant & SKU Support:** প্রোডাক্টের কালার, সাইজ, বা স্পেসিফিক ভ্যারিয়েন্ট সহ Add to Cart হবে।
4. **Stock & Quantity Guard:** স্টক লিমিটের বেশি Quantity বাড়ানো যাবে না।
5. **Real-time Calculations:** Subtotal, Discount, Delivery Fee, and Final Payable Amount রিয়েলটাইমে রিয়েক্টিভভাবে হিসেব হবে।

---

## 📐 Architecture & Data Flow

```
┌────────────────────────────────────────────────────────────────────────┐
│                        CART ARCHITECTURE FLOW                          │
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  ProductCard / ProductDetail                                           │
│       │                                                                │
│       ▼                                                                │
│  CartService (GetX Global Singleton) ◄───► GetStorage (Local Backup)   │
│       │                                                                │
│       ├────────────── Logged In? ──────────────┐                       │
│       │ YES                                    │ NO                    │
│       ▼                                        ▼                       │
│  CartProvider                             Local State                  │
│       │                                 (Guest Persistent)             │
│       ▼                                                                │
│  FastAPI Backend (/api/v1/cart)                                        │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 🔌 PART 1 — Backend API (FastAPI)

### 1. Database Model — `app/cart/model.py`

```python
from sqlmodel import SQLModel, Field, Relationship
from typing import Optional
from datetime import datetime

class CartItem(SQLModel, table=True):
    __tablename__ = "cart_items"

    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="user.id", ondelete="CASCADE", index=True)
    product_id: int = Field(foreign_key="product.id", ondelete="CASCADE")
    variant_id: Optional[int] = Field(default=None, foreign_key="product_variant.id")
    quantity: int = Field(default=1, ge=1)
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)

    # Relationships
    # product: Optional["Product"] = Relationship()
    # variant: Optional["ProductVariant"] = Relationship()
```

### 2. API Endpoints — `app/cart/router.py`

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `GET` | `/api/v1/cart` | ✅ Required | ইউজার কার্টের সব আইটেম + স্টোর গ্রুপ + হিসেব |
| `POST` | `/api/v1/cart/items` | ✅ Required | প্রোডাক্ট কার্টে যোগ করা (বা quantity বাড়ানো) |
| `PUT` | `/api/v1/cart/items/{item_id}` | ✅ Required | Quantity আপডেট করা |
| `DELETE` | `/api/v1/cart/items/{item_id}` | ✅ Required | কার্ট থেকে আইটেম রিমুভ |
| `POST` | `/api/v1/cart/merge` | ✅ Required | গেস্ট কার্টের আইটেম সার্ভারে সিন্ক/মার্জ করা |
| `DELETE` | `/api/v1/cart/clear` | ✅ Required | পুরো কার্ট খালি করা |

### 3. Response Schema (Multi-Vendor Structured)

```json
{
  "stores": [
    {
      "store_id": 5,
      "store_name": "Tech Gadgets BD",
      "store_logo": "https://...",
      "items": [
        {
          "cart_item_id": 102,
          "product_id": 42,
          "product_title": "Wireless Earbuds X",
          "thumbnail": "https://...",
          "variant": { "id": 7, "name": "Black / Noise Cancelling" },
          "unit_price": 2500.0,
          "discount_price": 2200.0,
          "stock_available": 15,
          "quantity": 2,
          "item_total": 4400.0
        }
      ],
      "store_subtotal": 4400.0
    }
  ],
  "summary": {
    "total_items": 2,
    "subtotal": 4400.0,
    "discount_total": 600.0,
    "estimated_delivery_fee": 120.0,
    "grand_total": 4520.0
  }
}
```

---

## 📱 PART 2 — Flutter Layer & State Management

### 🗂️ ফাইল ডিরেক্টরি Structure

```
lib/app/
├── data/
│   ├── models/
│   │   ├── cart_item_model.dart        ← Cart item + Variant details
│   │   └── cart_summary_model.dart     ← Calculation breakdown
│   └── providers/
│       └── cart_provider.dart          ← API calls (Dio)
│
├── core/
│   └── services/
│       └── cart_service.dart           ← ★ Global Singleton Cart Service (Rx State)
│
└── modules/
    └── cart/                           ← Cart Screen Module
        ├── bindings/cart_binding.dart
        ├── controllers/cart_controller.dart
        └── views/
            ├── cart_view.dart          ← Main Cart Screen
            └── widgets/
                ├── cart_store_group_card.dart  ← Vendor-wise grouped items
                ├── cart_item_tile.dart        ← Item card with quantity stepper
                └── cart_summary_bottom_bar.dart ← Sticky checkout bar
```

---

## 🧩 PART 3 — Key Code Implementations

### 1. `cart_service.dart` — (Global State with Hybrid Local/Server Backup)

```dart
class CartService extends GetxService {
  static CartService get to => Get.find();

  final CartProvider _provider = CartProvider();
  final _storage = StorageService.to;

  // Reactive State
  final cartItems = <CartItemModel>[].obs;
  final isLoading = false.obs;

  // Rx Computed Properties
  int get totalItemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => cartItems.fold(0.0, (sum, item) => sum + (item.effectivePrice * item.quantity));
  double get totalSavings => cartItems.fold(0.0, (sum, item) => sum + (item.savings * item.quantity));

  @override
  void onInit() {
    super.onInit();
    initCart();
  }

  Future<void> initCart() async {
    if (_storage.isLoggedIn) {
      await fetchServerCart();
    } else {
      loadLocalCart();
    }
  }

  // Add or Increase Quantity (Optimistic UI)
  Future<void> addToCart(ProductModel product, {VariantModel? variant, int qty = 1}) async {
    final existingIndex = cartItems.indexWhere(
      (item) => item.productId == product.id && item.variantId == variant?.id
    );

    if (existingIndex != -1) {
      // Increase Quantity
      final item = cartItems[existingIndex];
      updateQuantity(item.id, item.quantity + qty);
      return;
    }

    // New Item Add
    final newItem = CartItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // temp ID for local
      productId: product.id,
      productTitle: product.title,
      thumbnail: product.thumbnail,
      price: product.price,
      discountPrice: product.discountPrice,
      quantity: qty,
      storeId: product.storeId,
      storeName: product.storeName,
      variantId: variant?.id,
      variantName: variant?.name,
      maxStock: product.stock,
    );

    cartItems.add(newItem);
    _saveLocalCart();

    if (_storage.isLoggedIn) {
      try {
        await _provider.addToCart(productId: product.id, variantId: variant?.id, quantity: qty);
        await fetchServerCart(); // Sync exact server state
      } catch (e) {
        // Handle error gracefully
      }
    }
  }

  // Quantity Stepper (+ / -)
  Future<void> updateQuantity(String cartItemId, int newQty) async {
    if (newQty < 1) return;
    
    final index = cartItems.indexWhere((item) => item.id == cartItemId);
    if (index == -1) return;

    if (newQty > cartItems[index].maxStock) {
      Get.snackbar('Stock Limit', 'Only ${cartItems[index].maxStock} items available in stock');
      return;
    }

    cartItems[index] = cartItems[index].copyWith(quantity: newQty);
    _saveLocalCart();

    if (_storage.isLoggedIn) {
      await _provider.updateQuantity(cartItemId, newQty);
    }
  }

  // Merge Local Cart to Server on Login Event
  Future<void> mergeLocalCartOnLogin() async {
    if (cartItems.isEmpty) return;
    
    final localItemsPayload = cartItems.map((e) => {
      'product_id': e.productId,
      'variant_id': e.variantId,
      'quantity': e.quantity,
    }).toList();

    try {
      await _provider.mergeCart(localItemsPayload);
      await fetchServerCart();
    } catch (e) {
      print("Cart merge error: $e");
    }
  }

  void _saveLocalCart() {
    _storage.write('guest_cart', cartItems.map((e) => e.toJson()).toList());
  }

  void loadLocalCart() {
    final rawData = _storage.read<List>('guest_cart');
    if (rawData != null) {
      cartItems.value = rawData.map((e) => CartItemModel.fromJson(e)).toList();
    }
  }
}
```

---

## 🎨 PART 4 — Product Detail Variant Modal & Add to Cart UX

### Flow: Add to Cart button on Product Detail

```
[Add to Cart Button Pressed]
          │
          ▼
   Product has Variants?
    ├─ YES ──► BottomSheet Opens (Select Color/Size + Quantity Stepper) ──► Confirm Add
    └─ NO  ──► Instant Add to Cart (Optimistic UI + Badge Animate)
```

---

## 🛍️ PART 5 — UI Layouts & Mockup Designs

### 1. Bottom Nav Cart Badge Counter

```dart
// Dynamic Badge on Cart Tab
Obx(() {
  final count = CartService.to.totalItemCount;
  return Badge(
    isLabelVisible: count > 0,
    label: Text('$count'),
    child: Icon(Icons.shopping_cart_outlined),
  );
})
```

### 2. Multi-Vendor Grouped Cart View Layout

```
┌───────────────────────────────────────────────┐
│ 🛒 My Shopping Cart (3 Items)                 │
├───────────────────────────────────────────────┤
│                                               │
│ 🏪 Store: Tech Gadgets BD                     │
│ ┌───────────────────────────────────────────┐ │
│ │ [Image] Wireless Earbuds                  │ │
│ │         Color: Black                      │ │
│ │         ৳2,200  ~~৳2,500~~                │ │
│ │         [-  2  +]           [🗑️ Delete]   │ │
│ └───────────────────────────────────────────┘ │
│                                               │
│ 🏪 Store: Fashion Hub                         │
│ ┌───────────────────────────────────────────┐ │
│ │ [Image] Denim Jacket                      │ │
│ │         Size: L                           │ │
│ │         ৳1,800                            │ │
│ │         [-  1  +]           [🗑️ Delete]   │ │
│ └───────────────────────────────────────────┘ │
│                                               │
├───────────────────────────────────────────────┤
│ 🏷️ Promo Code / Coupon [ Apply ]              │
├───────────────────────────────────────────────┤
│ Order Summary:                                │
│ Subtotal:                           ৳4,000    │
│ Discount Savings:                   - ৳300    │
│ Delivery Fee:                        ৳120    │
├───────────────────────────────────────────────┤
│ Total Payable:                      ৳3,820    │
│ [ PROCEED TO CHECKOUT  → ]                    │
└───────────────────────────────────────────────┘
```

---

## 📋 PART 6 — Step-by-Step Implementation Sequence

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 BACKEND (FastAPI)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
STEP B-1  app/cart/model.py       ← SQLModel table for cart_items
STEP B-2  app/cart/schema.py      ← Requests & Grouped Response Schemas
STEP B-3  app/cart/router.py      ← CRUD + Merge endpoints
STEP B-4  main.py                 ← Register cart router

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 FLUTTER (Data & Core Layer)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
STEP F-1  cart_item_model.dart    ← Dart model with variant support
STEP F-2  cart_provider.dart      ← Dio API calls
STEP F-3  cart_service.dart       ← GetX Global Rx Singleton (Hybrid Sync)
STEP F-4  main.dart / AuthEvent   ← Call mergeLocalCartOnLogin() on auth success

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 FLUTTER (UI Integration)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
STEP F-5  gm_product_card.dart    ← Add to cart quick button
STEP F-6  product_detail_view.dart← BottomSheet for Variant Selection
STEP F-7  main_wrapper_view.dart  ← Cart Badge Counter on Bottom Nav
STEP F-8  modules/cart/           ← CartView with Vendor grouping & Checkout bar
```

---

## ✅ Definition of Done (DoD)

- [ ] **Guest Add to Cart:** আন-অথেন্টিকেটেড অবস্থায় কার্টে অ্যাড হবে এবং অ্যাপ রিস্টার্ট করলেও লোকাল কার্ট থাকবে।
- [ ] **On-Login Merge:** ইউজার লগইন করা মাত্রই গেস্ট কার্টের আইটেম ডাটাবেজের সাথে মার্জ হয়ে যাবে।
- [ ] **Multi-Vendor Grouping:** কার্ট স্ক্রিনে স্টোর অনুযায়ী আলাদা সেকশনে প্রোডাক্ট দেখাবে।
- [ ] **Variant Guard:** প্রোডাক্টের নির্দিষ্ট কালার/সাইজ নির্বাচন না করে কার্টে যোগ করা যাবে না (যদি প্রোডাক্ট ভ্যারিয়েন্ট থাকে)।
- [ ] **Stock Stepper Limit:** স্টকে থাকা সর্বোচ্চ পরিমাণের চেয়ে বেশি আইটেম বাড়াতে গেলে Snackbar অ্যালার্ট দেবে।
- [ ] **Instant Calculation:** Quantity বাড়ানো/কমানোর সাথে সাথে Subtotal, Total Savings এবং Dynamic Badge সরাসরি আপডেট হবে।
- [ ] **Swipe / Delete:** যেকোনো প্রোডাক্ট রিমুভ করার জন্য Confirmation Dialog বা Swipe gesture কাজ করবে।
- [ ] **Empty Cart State:** কার্ট খালি থাকলে সুন্দর Lottie এনিমেশন সহ "Shop Now" বাটন দেখাবে।
