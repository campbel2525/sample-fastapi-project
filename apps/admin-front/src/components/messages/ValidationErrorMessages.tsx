'use client'

import type { validationErrorDetail } from '@/types/responses/base-responses'

interface Props {
  validationErrors: validationErrorDetail[]
}

export default function ValidationErrorMessages({ validationErrors }: Props) {
  return (
    <div>
      {validationErrors.map((error, index) => (
        <div key={index}>
          {error.loc[0]}: {error.msg}
        </div>
      ))}
    </div>
  )
}
