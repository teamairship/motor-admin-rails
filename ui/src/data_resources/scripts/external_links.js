import { reactive } from 'vue'

const appNode = document.getElementById('app')

const externalLinks = reactive(JSON.parse(appNode.getAttribute('data-external-links')))

export { externalLinks }