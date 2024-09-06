<template>
  <div class="ml-3">
    <div class="ivu-card ivu-card-bordered">
      <div class="ivu-card-body">
        <h3 class="mb-3">
          {{ title }}
        </h3>
        <VForm>
          <FormItem :label="i18n['name']" prop="name">
            <VInput v-model="modelValue.name" size="large" :placeholder="i18n['name']" />
          </FormItem>

          <FormItem :label="i18n['url']" prop="url">
            <VInput v-model="modelValue.url" size="large" :placeholder="i18n['url']" />
          </FormItem>

          <FormItem>
            <Checkbox v-model="modelValue.relative">
              {{ ' ' }} {{ i18n['relative'] }}
            </Checkbox>
          </FormItem>

          <div class="d-flex justify-content-between">
            <VButton @click="$emit('cancel')">
              {{ i18n['cancel'] }}
            </VButton>

            <VButton @click="$emit('submit', modelValue)" type="primary">
              {{ i18n['save'] }}
            </VButton>

          </div>

        </VForm>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ResourceExternalLinkForm',
  emits: ['submit', 'cancel'],
  props: {
    modelValue: {
      type: Object,
      required: false,
      default: () => {
      return {
        name: '',
        url: '',
        relative: false,
        preferences: {
        icon: 'database',
        visible: true
        }
      }
      }
    }
  },
  computed: {
    title() {
      if(this.modelValue.id) {
        return this.i18n['edit_external_link']
      } else {
        return this.i18n['add_external_link']
      }
    }
  }
};
</script>

<style scoped>
/* Add any scoped styles here if needed */
</style>