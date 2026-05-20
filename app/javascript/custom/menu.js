// Hàm helper dùng chung để xử lý toggle class cho một phần tử
function addToggleListener(trigger_id, target_selector, toggle_class) {
    let trigger_element = document.querySelector(`#${trigger_id}`);
    
    // Kiểm tra an toàn đề phòng trường hợp User chưa Log-in (nút Account không tồn tại trên giao diện)
    if (!trigger_element) return; 

    trigger_element.addEventListener("click", function(event) {
        event.preventDefault();
        let target_element = document.querySelector(target_selector);
        if (target_element) {
            target_element.classList.toggle(toggle_class);
        }
    });
}

// Lắng nghe sự kiện Turbo Load (thay thế cho DOMContentLoaded trong Rails)
document.addEventListener("turbo:load", function() {
    // 1. Cho nút Hamburger trên điện thoại: Thao tác trực tiếp với menu dựa trên class 'collapse'
    addToggleListener("hamburger", "#navbar-menu", "collapse");

    // 2. Cho nút Account: Tìm thẻ cha <li> có class 'dropdown' và thêm/bớt class 'open'
    // Cú pháp "#account" -> tìm nút, thêm "..." -> trỏ ngược lên thẻ cha gần nhất thỏa mãn điều kiện
    let accountBtn = document.querySelector("#account");
    if (accountBtn) {
        accountBtn.addEventListener("click", function(event) {
            event.preventDefault();
            let parentLi = accountBtn.closest(".dropdown"); // Tìm thẻ <li> bọc ngoài
            if (parentLi) {
                parentLi.classList.toggle("open"); // Bootstrap 3 dùng class 'open' để hiển thị menu con
            }
        });
    }
});