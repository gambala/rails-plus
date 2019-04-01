import $ from 'jquery';

const url = (route, name = 'appRoot') => {
  const prefix = $(`meta[name="${name}"]`)[0].content;
  return `${prefix}${route}`;
}

export default url;
