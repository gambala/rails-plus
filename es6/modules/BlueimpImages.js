const initElement = (node) => {
  $(node).wrap(`<a href="${node.getAttribute('src')}" target="_blank" data-gallery=""></a>`);
  node.classList.add('blueimp-image_initialized');
};

const initAll = () => {
  const nodes = document.querySelectorAll('.blueimp-image:not(.blueimp-image_initialized)');
  [...nodes].forEach(node => initElement(node));
};

const start = () => {
  document.addEventListener('page:load', initAll);
  document.addEventListener('ajax:success', initAll);
};

export default { initAll, initElement, start };
